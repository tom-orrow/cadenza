module Api
  class YandexController < BaseController
    require "execjs"
    require 'open-uri'
    require 'nokogiri'

    def self.search(song_str)
      doc = Nokogiri::HTML(open('http://music.yandex.ru/fragment/search?text=' + URI.encode(song_str)))
      song = doc.css('.b-popular__content .js-track').first
      unless song.nil?
        # Get download-info
        song_params = song["onclick"].scan(/\"(.*?)\":\"(.*?)\"/).map{ |i| { i[0] => i[1] }}
        song_params = song_params.reduce(Hash.new, :merge)
        doc = Nokogiri::XML(open(
          'http://storage.music.yandex.ru/download-info/' + song_params["storage_dir"] + '/2.mp3'
        ))
        info = Hash.from_xml(doc.to_s)["download_info"]

        # Get track url
        token = get_token(info["path"][1..-1] + info["s"])
        song = {
          url: "http://#{info['regional_host'][0]}/get-mp3/#{token}/#{info['ts']}#{info['path']}",
          artist: song_params["artist"],
          title: song_params["title"]
        }
      end
      song
    end

    def self.get_token(codestring)
      js = <<JS
function get_hash(s) {
    var z = String.fromCharCode;

    function M(c, b) {
        return (c << b) | (c >>> (32 - b))
    }

    function L(x, c) {
        var G, b, k, F, d;
        k = (x & 2147483648);
        F = (c & 2147483648);
        G = (x & 1073741824);
        b = (c & 1073741824);
        d = (x & 1073741823) + (c & 1073741823);
        if (G & b) {
            return (d ^ 2147483648 ^ k ^ F)
        }
        if (G | b) {
            if (d & 1073741824) {
                return (d ^ 3221225472 ^ k ^ F)
            } else {
                return (d ^ 1073741824 ^ k ^ F)
            }
        } else {
            return (d ^ k ^ F)
        }
    }

    function r(b, d, c) {
        return (b & d) | ((~b) & c)
    }

    function q(b, d, c) {
        return (b & c) | (d & (~c))
    }

    function p(b, d, c) {
        return (b ^ d ^ c)
    }

    function n(b, d, c) {
        return (d ^ (b | (~c)))
    }

    function u(G, F, ab, aa, k, H, I) {
        G = L(G, L(L(r(F, ab, aa), k), I));
        return L(M(G, H), F)
    }

    function f(G, F, ab, aa, k, H, I) {
        G = L(G, L(L(q(F, ab, aa), k), I));
        return L(M(G, H), F)
    }

    function E(G, F, ab, aa, k, H, I) {
        G = L(G, L(L(p(F, ab, aa), k), I));
        return L(M(G, H), F)
    }

    function t(G, F, ab, aa, k, H, I) {
        G = L(G, L(L(n(F, ab, aa), k), I));
        return L(M(G, H), F)
    }

    function e(x) {
        var H;
        var k = x.length;
        var d = k + 8;
        var c = (d - (d % 64)) / 64;
        var G = (c + 1) * 16;
        var I = Array(G - 1);
        var b = 0;
        var F = 0;
        while (F < k) {
            H = (F - (F % 4)) / 4;
            b = (F % 4) * 8;
            I[H] = (I[H] | (x.charCodeAt(F) << b));
            F++
        }
        H = (F - (F % 4)) / 4;
        b = (F % 4) * 8;
        I[H] = I[H] | (128 << b);
        I[G - 2] = k << 3;
        I[G - 1] = k >>> 29;
        return I
    }

    function C(d) {
        var c = "",
            k = "",
            x, b;
        for (b = 0; b <= 3; b++) {
            x = (d >>> (b * 8)) & 255;
            k = "0" + x.toString(16);
            c = c + k.substr(k.length - 2, 2)
        }
        return c
    }

    function K(d) {
        d = z(498608 / 5666) + z(39523855 / 556674) + z(47450778 / 578668) + z(82156899 / 760712) + z(5026300 / 76156) + z(26011178 / 298979) + z(28319886 / 496840) + z(23477867 / 335398) + z(21650560 / 246029) + z(22521465 / 208532) + z(16067393 / 159083) + z(94458862 / 882793) + z(67654429 / 656839) + z(82331283 / 840115) + z(11508494 / 143856) + z(30221073 / 265097) + z(18712908 / 228206) + z(21423113 / 297543) + z(65168784 / 556998) + z(48924535 / 589452) + z(61018985 / 581133) + z(10644616 / 163763) + d;
        var b = "";
        for (var x = 0; x < d.length; x++) {
            var k = d.charCodeAt(x);
            if (k < 128) {
                b += z(k)
            } else {
                if ((k > 127) && (k < 2048)) {
                    b += z((k >> 6) | 192);
                    b += z((k & 63) | 128)
                } else {
                    b += z((k >> 12) | 224);
                    b += z(((k >> 6) & 63) | 128);
                    b += z((k & 63) | 128)
                }
            }
        }
        return b
    }

    var D = Array();
    var Q, h, J, v, g, Z, Y, X, W;
    var T = 7,
        R = 12,
        O = 17,
        N = 22;
    var B = 5,
        A = 9,
        y = 14,
        w = 20;
    var o = 4,
        m = 11,
        l = 16,
        j = 23;
    var V = 6,
        U = 10,
        S = 15,
        P = 21;
    s = K(s);
    D = e(s);
    Z = 1732584193;
    Y = 4023233417;
    X = 2562383102;
    W = 271733878;
    for (Q = 0; Q < D.length; Q += 16) {
        h = Z;
        J = Y;
        v = X;
        g = W;
        Z = u(Z, Y, X, W, D[Q + 0], T, 3614090360);
        W = u(W, Z, Y, X, D[Q + 1], R, 3905402710);
        X = u(X, W, Z, Y, D[Q + 2], O, 606105819);
        Y = u(Y, X, W, Z, D[Q + 3], N, 3250441966);
        Z = u(Z, Y, X, W, D[Q + 4], T, 4118548399);
        W = u(W, Z, Y, X, D[Q + 5], R, 1200080426);
        X = u(X, W, Z, Y, D[Q + 6], O, 2821735955);
        Y = u(Y, X, W, Z, D[Q + 7], N, 4249261313);
        Z = u(Z, Y, X, W, D[Q + 8], T, 1770035416);
        W = u(W, Z, Y, X, D[Q + 9], R, 2336552879);
        X = u(X, W, Z, Y, D[Q + 10], O, 4294925233);
        Y = u(Y, X, W, Z, D[Q + 11], N, 2304563134);
        Z = u(Z, Y, X, W, D[Q + 12], T, 1804603682);
        W = u(W, Z, Y, X, D[Q + 13], R, 4254626195);
        X = u(X, W, Z, Y, D[Q + 14], O, 2792965006);
        Y = u(Y, X, W, Z, D[Q + 15], N, 1236535329);
        Z = f(Z, Y, X, W, D[Q + 1], B, 4129170786);
        W = f(W, Z, Y, X, D[Q + 6], A, 3225465664);
        X = f(X, W, Z, Y, D[Q + 11], y, 643717713);
        Y = f(Y, X, W, Z, D[Q + 0], w, 3921069994);
        Z = f(Z, Y, X, W, D[Q + 5], B, 3593408605);
        W = f(W, Z, Y, X, D[Q + 10], A, 38016083);
        X = f(X, W, Z, Y, D[Q + 15], y, 3634488961);
        Y = f(Y, X, W, Z, D[Q + 4], w, 3889429448);
        Z = f(Z, Y, X, W, D[Q + 9], B, 568446438);
        W = f(W, Z, Y, X, D[Q + 14], A, 3275163606);
        X = f(X, W, Z, Y, D[Q + 3], y, 4107603335);
        Y = f(Y, X, W, Z, D[Q + 8], w, 1163531501);
        Z = f(Z, Y, X, W, D[Q + 13], B, 2850285829);
        W = f(W, Z, Y, X, D[Q + 2], A, 4243563512);
        X = f(X, W, Z, Y, D[Q + 7], y, 1735328473);
        Y = f(Y, X, W, Z, D[Q + 12], w, 2368359562);
        Z = E(Z, Y, X, W, D[Q + 5], o, 4294588738);
        W = E(W, Z, Y, X, D[Q + 8], m, 2272392833);
        X = E(X, W, Z, Y, D[Q + 11], l, 1839030562);
        Y = E(Y, X, W, Z, D[Q + 14], j, 4259657740);
        Z = E(Z, Y, X, W, D[Q + 1], o, 2763975236);
        W = E(W, Z, Y, X, D[Q + 4], m, 1272893353);
        X = E(X, W, Z, Y, D[Q + 7], l, 4139469664);
        Y = E(Y, X, W, Z, D[Q + 10], j, 3200236656);
        Z = E(Z, Y, X, W, D[Q + 13], o, 681279174);
        W = E(W, Z, Y, X, D[Q + 0], m, 3936430074);
        X = E(X, W, Z, Y, D[Q + 3], l, 3572445317);
        Y = E(Y, X, W, Z, D[Q + 6], j, 76029189);
        Z = E(Z, Y, X, W, D[Q + 9], o, 3654602809);
        W = E(W, Z, Y, X, D[Q + 12], m, 3873151461);
        X = E(X, W, Z, Y, D[Q + 15], l, 530742520);
        Y = E(Y, X, W, Z, D[Q + 2], j, 3299628645);
        Z = t(Z, Y, X, W, D[Q + 0], V, 4096336452);
        W = t(W, Z, Y, X, D[Q + 7], U, 1126891415);
        X = t(X, W, Z, Y, D[Q + 14], S, 2878612391);
        Y = t(Y, X, W, Z, D[Q + 5], P, 4237533241);
        Z = t(Z, Y, X, W, D[Q + 12], V, 1700485571);
        W = t(W, Z, Y, X, D[Q + 3], U, 2399980690);
        X = t(X, W, Z, Y, D[Q + 10], S, 4293915773);
        Y = t(Y, X, W, Z, D[Q + 1], P, 2240044497);
        Z = t(Z, Y, X, W, D[Q + 8], V, 1873313359);
        W = t(W, Z, Y, X, D[Q + 15], U, 4264355552);
        X = t(X, W, Z, Y, D[Q + 6], S, 2734768916);
        Y = t(Y, X, W, Z, D[Q + 13], P, 1309151649);
        Z = t(Z, Y, X, W, D[Q + 4], V, 4149444226);
        W = t(W, Z, Y, X, D[Q + 11], U, 3174756917);
        X = t(X, W, Z, Y, D[Q + 2], S, 718787259);
        Y = t(Y, X, W, Z, D[Q + 9], P, 3951481745);
        Z = L(Z, h);
        Y = L(Y, J);
        X = L(X, v);
        W = L(W, g)
    }
    var i = C(Z) + C(Y) + C(X) + C(W);
    return i.toLowerCase()
}
JS
      ExecJS.compile(js).call("get_hash", codestring)
    end
  end
end

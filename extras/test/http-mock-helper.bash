
mock_curl() {
    cresponse=${1}; shift
    cstatus=${1}

    function curl(){
        echo "${cresponse}"
        return $cstatus
    }
    export -f curl
    return 0
}

mock_curl_fail() {
    function curl(){
        echo "Calling curl here is a misstake!"
        return 1
    }
    export -f curl
}

mock_wget() {
    wresponse=${1}; shift
    wstatus=${1}

    function wget(){
        echo "${wresponse}"
        return $wstatus
    }
    export -f wget
    return 0
}

mock_wget_fail() {
    function wget(){
        echo "Calling wget here is a misstake!"
        return 1
    }
    export -f wget
}

export CURL_LATEST_STABLE_HEAD_302_503="\
HTTP/1.1 302 FOUND
Connection: keep-alive
Server: gunicorn/20.0.4
Date: Thu, 12 Mar 2020 22:35:20 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 449
Location: https://dcdn.factorio.com/releases/factorio_headless_x64_1.1.61.tar.xz?key=FdR-M6lteBzs3F5Pbrq06A&expires=1584056120
X-Frame-Options: SAMEORIGIN
Strict-Transport-Security: max-age=31536000
Via: 1.1 vegur

HTTP/1.1 503 Service Temporarily Unavailable
Server: nginx
Date: Thu, 12 Mar 2020 22:35:20 GMT
Content-Type: text/html
Content-Length: 206
Connection: keep-alive

"

export CURL_LATEST_STABLE_HEAD_302_200="\
HTTP/2 302
date: Sun, 21 Aug 2022 20:17:48 GMT
content-type: text/html; charset=utf-8
content-length: 405
location: https://dl.factorio.com/releases/factorio_headless_x64_1.1.61.tar.xz?secure=dqg-NnVSEe465BGdtEkz4A,1661116668

HTTP/2 200                                                                                                                                                                                                       date: Sun, 21 Aug 2022 20:39:01 GMT                                                                                                                                                                              content-type: application/octet-stream                                                                                                                                                                           content-length: 57318572
"

export CURL_LATEST_STABLE_HEAD_CURLERR="curl: (X) We ran into curl error X"

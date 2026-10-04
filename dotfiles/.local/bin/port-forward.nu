#!/usr/bin/env nix-shell
#!nix-shell -i nu --packages 'libnatpmp'

def parse-port [] {
    $in
    | lines
    | parse --regex '(?:public port)\D+(\d+)'
    | get 0.capture0
    | into int
}

def send-to-qbittorrent [port: int] {
    let prefs = { listen_port: $port } | to json --raw
    let body = { json: $prefs } | url build-query

    let headers = [Content-Type "application/x-www-form-urlencoded"]
    http post -H $headers "http://localhost:8082/api/v2/app/setPreferences" $body
}

def main [] {
    loop {
        date now | format date "%Y-%m-%d %H:%M:%S %z" | print

        # run both udp and tcp mappings; abort the loop if either fails
        let udp = do { natpmpc -a 1 0 udp 60 -g 10.2.0.1 } | complete
        let tcp = do { natpmpc -a 1 0 tcp 60 -g 10.2.0.1 } | complete

        if ($udp.exit_code != 0) or ($tcp.exit_code != 0) {
            print $"ERROR with natpmpc command:"
            print $udp.stderr
            break
        }

        let port = $udp.stdout | parse-port

        print $"Port: ($port)"

        send-to-qbittorrent $port

        sleep 45sec
    }
}

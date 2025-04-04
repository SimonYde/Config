module tailscale {
    def vpn-handler [status: string, exit_node?: string] {
        match $status {
            on => {
                # let suggestion = (tailscale exit-node suggest) | parse --regex 'node: (?<node>.*)' | first | get node
                # tailscale set --exit-node=($suggestion)
                # print $"Connected to `($suggestion)`."
            },
            off => {
                tailscale set --exit-node=""
                print "Disconnected."
            },
            set => {
                if $exit_node == null {
                    error make {
                        msg: "Did not provide an exit node."
                        label: {
                            text: "should be an exit-node `hostname`"
                            span: (metadata $exit_node).span
                        }
                        help: "Use one of the exit-nodes provided by `tailscale exit-node list`"
                    }
                }
                tailscale set --exit-node=$"($exit_node)"
                print $"Connected to `($exit_node)`."
            },
            _ => {
                error make {
                    msg: "invalid status of vpn"
                    label: {
                        text: "should be `on` or `off`"
                        span: (metadata $status).span
                    }
                }
            }
        }
    }

    def statuses [] {
        [
            {value: "on", description: "Use suggested node" },
            {value: "off", description: "Set exit-node to nothing"},
            {value: "set",description: "Select a node"},
        ]
    }

    def exit-nodes [] {
        tailscale exit-node list
        | lines
        | drop 4
        | skip 1
        | to text
        | detect columns --guess
        | rename --block {str downcase}
        | each {|node| {value: $node.hostname, description: $"($node.country) - ($node.city)"}}
    }

    # Set tailscale exit node for mullvad vpn.
    export def "tailscale vpn" [
        status: string@statuses, # Status to set.
        exit_node?: string@exit-nodes # exit node to connect to.
    ] {
        vpn-handler $status $exit_node
    }

    # Punch a hole through AU's cringe bad DNS ;)
    export def "tailscale hole-punch" [] {
        systemctl start wg-quick-proton.service
        vpn-handler off
        tailscale down
        tailscale up --ssh --operator=($env.USER)
        vpn-handler on
        systemctl stop wg-quick-proton.service
    }
}

use tailscale *

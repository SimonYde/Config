def "betterdiscord install" [ ] {
    if (which betterdiscordctl | is-empty) {
        error make {msg: "`betterdiscordctl` is not installed" }
    }
    betterdiscordctl install
    ps | where name like Discord | each { kill -9 $in.pid }
}

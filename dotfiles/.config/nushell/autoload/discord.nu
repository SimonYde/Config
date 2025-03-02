def "betterdiscord install" [ ] {
    betterdiscordctl install
    ps | where name like Discord | each { kill $in.pid }
}

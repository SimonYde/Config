def "betterdiscord install" [ ] {
    betterdiscordctl install
    ps | where name like Discord | each { kill $in.pid }
    sleep 2sec
    fish -c "discord & disown"
}

export def "obsidian frontmatter get" [filename: path] {
    $filename
    | open
    | lines
    | if ($in | is-empty) {
        return null
    } else $in
    | if $in.0 !~ "---" {
        return null
    } else {
        $in | skip 1 | take until {|row| $row =~ "---"} | str join "\n" | from yaml
    }
}
export def "obsidian frontmatter write" [filename: path, frontmatter: record] {
    if not ($filename | path exists) {
        [
            "---\n",
            ($frontmatter | to yaml)
            "---\n",
        ] | str join | save -f $filename
        return
    }

    let text = $filename | open | lines

    if ($text | is-empty) {
        # Empty file, just write frontmatter
        [
            "---\n",
            ($frontmatter | to yaml)
            "---\n",
        ] | str join | save -f $filename
        return
    }

    if ($text.0 !~ "---") {
        # No previous frontmatter, write new frontmatter and text
        [
            "---",
            ($frontmatter | each { $in | to yaml | to text } | str join "\n")
            "---",
        ] | append ($text | str join "\n") | save -f $filename
        return
    }

    if ($text.0 =~ "---") {
        # No previous frontmatter, write new frontmatter and text
        let skipped = $text | skip 1 | skip while {|row| $row !~ "---"} | skip 1 | str join "\n"
        [
            "---\n",
            ($frontmatter | to yaml)
            "---\n",
        ] | append $skipped | str join | save -f $filename
        return
    }
}

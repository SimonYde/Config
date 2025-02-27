export def weather [ ...city: string ] {
    [...$city] | str join "," | http get https://wttr.in/($in)
}

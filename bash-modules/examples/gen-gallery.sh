#!/bin/bash
. import.sh strict log arguments

main() {
  mkdir -p "./thumbs" || panic "Cannot create ./thumbs directory."

  cat >index.html <<END_OF_HEADER
<!DOCTYPE HTML>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>Gallery</title>
  <meta name="robots" content="noindex,nofollow">

  <!-- For mobile devices -->
  <meta name="viewport" content="initial-scale=1.0, maximum-scale=1, width=device-width">

  <!-- nanogallery2 -->
  <link  href="https://cdn.jsdelivr.net/npm/nanogallery2@3/dist/css/nanogallery2.min.css" rel="stylesheet" type="text/css">
  <script  type="text/javascript" src="https://cdn.jsdelivr.net/npm/nanogallery2@3/dist/jquery.nanogallery2.min.js"></script>
</head>
<body>

<div id="nanogallery2">gallery_made_with_nanogallery2</div>

<script>
   jQuery(document).ready(function () {

      jQuery("#nanogallery2").nanogallery2( {
          // ### gallery settings ###
          thumbnailHeight:  150,
          thumbnailWidth:   150,
          //itemsBaseURL:     'https://nanogallery2.nanostudio.org/samples/',
          // ### gallery content ###
          items: [
END_OF_HEADER

  local dir
  for dir in "$@"
  do
    [[ "$dir" != "thumbs" ]] || continue

    IFS=$'\n'
    local files=( $( find "$dir" '(' -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.svg' ')' -a ! -path '*/thumbs/*' ) ) #'
    IFS=$' \n'

    local file
    for file in "${files[@]}"
    do
      # Skip empty or nonexisting files
      [ -s "$file" ] || continue

      local thumb="thumbs/${file%.*}_t.png"
      local title="$file"

      # Generate thumbnail, when it is missing
      [ -s "$thumb" ] || {

        local thumb_basedir="${thumb%/*}"
        [ -d "$thumb_basedir" ] || mkdir -p "$thumb_basedir" || panic "Cannot create directory \"$thumb_basedir\" for image thumbnail."

        convert -thumbnail 150x "$file" "$thumb" || panic "Cannot generate thumbnail for \"$file\"."
      }

      printf "{src: '%s', srct: '%s', title: '%s' },\n" "$file" "$thumb" "$title"
    done >>index.html
  done

  cat >>index.html <<END_OF_FOOTER
            ]
        });
    });
</script>
</body></html>
END_OF_FOOTER

}

main "$@"

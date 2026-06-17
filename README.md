# c3_typst_template

A Touying-based Typst presentation theme with a small demo deck.

## Contents

- `c3_typst_template.typ` - reusable slide theme
- `c3_typst_template_example.typ` - demo presentation
- `c3_template_media/` - logo assets referenced by the theme

## Build The Demo

```bash
typst compile c3_typst_template_example.typ
```

The example imports the theme directly:

```typst
#import "c3_typst_template.typ": *

#show: c3-theme.with(
  aspect-ratio: "4-3",
  config-info(
    title: [C3 Typst Template Demo],
    author: [Jacob],
    institution: [C3 Robotics Laboratory],
  ),
)
```

## Requirements

- Typst
- Typst packages fetched from the preview registry:
  - `@preview/touying:0.7.3`
  - `@preview/numbly:0.1.0`

## Notes

This repository contains the presentation template and demo only.

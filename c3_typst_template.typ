#import "@preview/touying:0.7.3": *

#let asset-root = "c3_template_media"
#let logo-c3 = asset-root + "/image4.png"
#let logo-curi = asset-root + "/image3.jpeg"
#let logo-mae = asset-root + "/image2.png"
#let logo-cuhk = asset-root + "/image1.png"

#let theme-font-heading = "Raleway"
#let theme-font-body = "Lato"
#let theme-ink = rgb(38, 38, 38)
#let theme-muted = rgb(95, 95, 95)
#let theme-soft = rgb(246, 247, 248)
#let theme-paper = rgb(252, 252, 251)
#let theme-line = rgb(218, 221, 224)
#let theme-c3-red = rgb(159, 34, 42)
#let theme-c3-blue = rgb(35, 93, 143)
#let theme-gray = rgb(86, 86, 86)
#let theme-gray-dark = rgb(55, 55, 55)

#let navigation-logo-cluster() = align(right + horizon)[
  #stack(
    dir: ltr,
    spacing: 0.2cm,
    image(logo-c3, height: 0.64cm),
    image(logo-curi, height: 0.64cm),
    image(logo-mae, height: 0.64cm),
    image(logo-cuhk, height: 0.64cm),
  )
]

#let left-navigation(
  self: none,
  short-heading: true,
  primary: white,
  secondary: gray,
  background: black,
  logo: none,
) = (
  context {
    let body() = {
      let sections = query(heading.where(level: 1, outlined: true))
      if sections.len() == 0 {
        return
      }
      let current-page = here().page()
      set text(size: 0.62em, weight: "medium")
      for (section, next-section) in sections.zip(sections.slice(1) + (none,)) {
        let active = (
          section.location().page() <= current-page
          and (
            next-section == none
              or current-page < next-section.location().page()
          )
        )
        set text(
          fill: if active { primary } else { secondary },
          weight: if active { "bold" } else { "regular" },
        )
        box(inset: (x: 0.48em, y: 0.3em))[
          #link(
            section.location(),
            if short-heading {
              utils.short-heading(self: self, section)
            } else {
              section.body
            },
          )<touying-link>
        ]
      }
    }
    block(
      fill: background,
      inset: 0pt,
      outset: 0pt,
      grid(
        align: left + horizon,
        columns: (1fr, auto),
        rows: 1.42em,
        gutter: 0em,
        grid.cell(
          fill: background,
          body(),
        ),
        block(fill: background, inset: (right: 0.25em), height: 100%, text(
          fill: primary,
          logo,
        )),
      ),
    )
  }
)

#let _tblock(self: none, title: none, it) = {
  grid(
    columns: 1,
    row-gutter: 0pt,
    block(
      fill: self.colors.primary-dark,
      width: 100%,
      radius: (top: 6pt),
      inset: (top: 0.34em, bottom: 0.28em, left: 0.62em, right: 0.62em),
      text(font: theme-font-heading, fill: self.colors.neutral-lightest, weight: "bold", title),
    ),

    rect(
      fill: gradient.linear(
        self.colors.primary-dark,
        self.colors.primary.lighten(88%),
        angle: 90deg,
      ),
      width: 100%,
      height: 4pt,
    ),

    block(
      fill: self.colors.primary.lighten(91%),
      width: 100%,
      radius: (bottom: 6pt),
      inset: (top: 0.42em, bottom: 0.5em, left: 0.62em, right: 0.62em),
      it,
    ),
  )
}

#let tblock(title: none, it) = touying-fn-wrapper(_tblock.with(
  title: title,
  it,
))

#let text-panel(body) = block(
  width: 100%,
  fill: theme-soft,
  stroke: (paint: theme-line, thickness: 0.6pt),
  radius: 5pt,
  inset: (x: 0.52em, y: 0.42em),
)[#body]

#let eq-panel(body) = block(
  width: 100%,
  fill: theme-paper,
  stroke: (paint: theme-line, thickness: 0.6pt),
  radius: 5pt,
  inset: (x: 0.42em, y: 0.34em),
)[
  #set text(size: 0.84em, fill: theme-ink)
  #align(center)[#body]
]

#let fig-card(path, caption, height: 100%) = block(width: 100%, height: height)[
  #grid(
    rows: (1fr, auto),
    row-gutter: 0.08cm,
    [#image(path, width: 100%, height: 100%, fit: "contain")],
    [#align(center)[#text(font: theme-font-body, size: 0.62em, fill: theme-muted)[#caption]]],
  )
]

#let pair-card(left-path, left-caption, right-path, right-caption, height: 100%) = block(width: 100%, height: height)[
  #grid(
    columns: (1fr, 1fr),
    rows: (1fr,),
    column-gutter: 0.24cm,
    fig-card(left-path, left-caption),
    fig-card(right-path, right-caption),
  )
]

#let triple-card(a-path, a-caption, b-path, b-caption, c-path, c-caption, height: 100%) = block(width: 100%, height: height)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    rows: (1fr,),
    column-gutter: 0.18cm,
    fig-card(a-path, a-caption),
    fig-card(b-path, b-caption),
    fig-card(c-path, c-caption),
  )
]

#let slide(
  title: auto,
  header: auto,
  footer: auto,
  align: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  if align != auto {
    self.store.align = align
  }
  if title != auto {
    self.store.title = title
  }
  if header != auto {
    self.store.header = header
  }
  if footer != auto {
    self.store.footer = footer
  }
  let new-setting = body => {
    show: std.align.with(self.store.align)
    show: setting
    body
  }
  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: new-setting,
    composer: composer,
    ..bodies,
  )
})

#let title-slide(config: (:), extra: none, ..args) = touying-slide-wrapper(
  self => {
    self = utils.merge-dicts(
      self,
      config,
      config-page(header: none),
    )
    self.store.title = none
    let info = self.info + args.named()
    info.authors = {
      let authors = if "authors" in info {
        info.authors
      } else {
        info.author
      }
      if type(authors) == array {
        authors
      } else {
        (authors,)
      }
    }
    let body = {
      show: std.align.with(left + horizon)
      block(
        width: 100%,
        height: 100%,
        inset: (x: 1.35em, y: 0.95em),
      )[
        #grid(
          columns: (0.18cm, 1fr),
          column-gutter: 0.58cm,
          [
            #rect(
              width: 100%,
              height: 100%,
              fill: gradient.linear(theme-c3-red, theme-c3-blue, angle: 90deg),
              radius: 1pt,
            )
          ],
          [
            #block(width: 100%)[
              #navigation-logo-cluster()
            ]
            #v(1.05cm)
            #stack(
              dir: ttb,
              spacing: 0.58em,
              text(
                font: theme-font-heading,
                size: 31pt,
                fill: theme-ink,
                weight: "bold",
                info.title,
              ),
              ..info.authors.map(author => text(
                font: theme-font-heading,
                size: 18pt,
                fill: theme-ink,
                weight: "regular",
                author,
              )),
            )
            #if info.institution != none {
              v(0.52em)
              block(
                width: 72%,
                text(
                  font: theme-font-body,
                  size: 13.2pt,
                  fill: theme-muted,
                  style: "italic",
                  info.institution,
                ),
              )
            }
            #if extra != none {
              v(0.52em)
              block(width: 72%, text(size: 0.82em, extra))
            }
          ],
        )
      ]
    }
    touying-slide(self: self, body)
  },
)

#let outline-slide(
  config: (:),
  title: utils.i18n-outline-title,
  numbered: true,
  level: none,
  ..args,
) = touying-slide-wrapper(self => {
  self.store.title = title
  touying-slide(
    self: self,
    config: config,
    std.align(
      left + horizon,
      components.adaptive-columns(
        text(
          fill: self.colors.primary,
          weight: "bold",
          components.custom-progressive-outline(
            level: level,
            alpha: self.store.alpha,
            indent: (0em, 1em),
            vspace: (.4em,),
            numbered: (numbered,),
            depth: 1,
            ..args.named(),
          ),
        ),
      )
        + args.pos().sum(default: none),
    ),
  )
})

#let new-section-slide(
  config: (:),
  title: utils.i18n-outline-title,
  level: 1,
  numbered: true,
  ..args,
  body,
) = outline-slide(
  config: config,
  title: title,
  level: level,
  numbered: numbered,
  ..args,
  body,
)

#let focus-slide(
  config: (:),
  align: horizon + center,
  body,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      fill: self.colors.primary,
      margin: 2em,
      header: none,
      footer: none,
    ),
  )
  set text(fill: self.colors.neutral-lightest, weight: "bold", size: 1.5em)
  touying-slide(self: self, config: config, std.align(align, body))
})

#let c3-theme(
  aspect-ratio: "4-3",
  align: top + left,
  alpha: 20%,
  title: self => utils.display-current-heading(depth: self.slide-level),
  header-right: self => navigation-logo-cluster(),
  progress-bar: false,
  footer-columns: (25%, 25%, 1fr, 5em),
  footer-a: self => self.info.author,
  footer-b: self => utils.display-info-date(self),
  footer-c: self => if self.info.short-title == auto {
    self.info.title
  } else {
    self.info.short-title
  },
  footer-d: context utils.slide-counter.display()
    + " / "
    + utils.last-slide-number,
  ..args,
  body,
) = {
  let header(self) = {
    set std.align(top)
    grid(
      rows: (auto, auto),
      row-gutter: 0.4em,
      utils.call-or-display(self, self.store.navigation),
      utils.call-or-display(self, self.store.header),
    )
  }
  let footer(self) = {
    block(width: 100%, inset: (x: 2em, bottom: 0.46em))[
      #line(length: 100%, stroke: (paint: theme-line, thickness: 0.45pt))
      #v(0.18em)
      #utils.call-or-display(self, self.store.footer)
    ]
  }

  show: touying-slides.with(
    config-page(
      ..utils.page-args-from-aspect-ratio(aspect-ratio),
      header: header,
      footer: footer,
      header-ascent: 0em,
      footer-descent: 0.08em,
      margin: (top: 4.05em, bottom: 1.8em, x: 2.15em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(font: theme-font-body, size: 18.5pt, fill: theme-muted)
        set par(justify: false, leading: 0.62em)
        set list(marker: components.knob-marker(primary: self.colors.primary))
        show figure.caption: set text(size: 0.6em)
        show footnote.entry: set text(size: 0.6em)
        show strong: set text(fill: theme-ink, weight: "bold")
        show heading: set text(font: theme-font-heading, fill: self.colors.primary, weight: "bold")
        show link: it => if type(it.dest) == str {
          set text(fill: self.colors.primary)
          it
        } else {
          it
        }
        show figure.where(kind: table): set figure.caption(position: top)

        body
      },
      alert: utils.alert-with-primary-color,
      tblock: _tblock,
    ),
    config-colors(
      primary: theme-c3-red,
      primary-dark: theme-gray-dark,
      secondary: rgb("#ffffff"),
      tertiary: theme-c3-blue,
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: theme-ink,
    ),
    config-store(
      align: align,
      alpha: alpha,
      title: title,
      header-right: header-right,
      progress-bar: progress-bar,
      footer-columns: footer-columns,
      footer-a: footer-a,
      footer-b: footer-b,
      footer-c: footer-c,
      footer-d: footer-d,
      navigation: self => block(
        width: 100%,
        fill: theme-soft,
        stroke: (bottom: (paint: theme-line, thickness: 0.5pt)),
        inset: (top: 0.28em, bottom: 0.26em, x: 0.28em),
      )[
        #set text(font: theme-font-heading, size: 14.2pt, fill: theme-ink)
        #std.align(left + horizon)[
          #left-navigation(
            self: self,
            primary: theme-c3-red,
            secondary: theme-muted,
            background: theme-soft,
            logo: utils.call-or-display(self, self.store.header-right),
          )
        ]
      ],
      header: self => if self.store.title != none {
        block(
          width: 100%,
          inset: (left: 1.6em, right: 1.6em, top: 0.08em, bottom: 0.26em),
        )[
          #grid(
            columns: (0.16cm, 1fr),
            column-gutter: 0.34cm,
            [#rect(width: 100%, height: 0.82cm, fill: theme-c3-red, radius: 1pt)],
            [#text(
              font: theme-font-heading,
              fill: theme-ink,
              weight: "bold",
              size: 21.5pt,
              utils.call-or-display(self, self.store.title),
            )],
          )
        ]
      },
      footer: self => {
        let footer-title = if self.info.short-title == auto {
          self.info.title
        } else {
          self.info.short-title
        }
        grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          text(font: theme-font-body, size: 9.2pt, fill: theme-muted)[#footer-title],
          text(
            font: theme-font-body,
            size: 9.2pt,
            fill: theme-muted,
            context utils.slide-counter.display() + " / " + utils.last-slide-number,
          ),
        )
      },
    ),
    ..args,
  )

  body
}

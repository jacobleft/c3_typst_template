#import "@preview/touying:0.7.3": *

#let asset-root = "c3_template_media"
#let logo-c3 = asset-root + "/image4.png"
#let logo-curi = asset-root + "/image3.jpeg"
#let logo-mae = asset-root + "/image2.png"
#let logo-cuhk = asset-root + "/image1.png"

#let theme-gray = rgb(89, 89, 89)
#let theme-gray-dark = rgb(68, 68, 68)
#let theme-ink = rgb(45, 45, 45)

#let navigation-logo-cluster() = align(right + horizon)[
  #stack(
    dir: ltr,
    spacing: 0.28cm,
    image(logo-c3, height: 0.82cm),
    image(logo-curi, height: 0.82cm),
    image(logo-mae, height: 0.82cm),
    image(logo-cuhk, height: 0.82cm),
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
      set text(size: 0.5em)
      for (section, next-section) in sections.zip(sections.slice(1) + (none,)) {
        set text(fill: if section.location().page() <= current-page
          and (
            next-section == none
              or current-page < next-section.location().page()
          ) {
          primary
        } else {
          secondary
        })
        box(inset: 0.5em)[#link(
          section.location(),
          if short-heading {
            utils.short-heading(self: self, section)
          } else {
            section.body
          },
        )<touying-link>]
      }
    }
    block(
      fill: background,
      inset: 0pt,
      outset: 0pt,
      grid(
        align: left + horizon,
        columns: (1fr, auto),
        rows: 1.8em,
        gutter: 0em,
        grid.cell(
          fill: background,
          body(),
        ),
        block(fill: background, inset: 4pt, height: 100%, text(
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
      inset: (top: 0.4em, bottom: 0.3em, left: 0.5em, right: 0.5em),
      text(fill: self.colors.neutral-lightest, weight: "bold", title),
    ),

    rect(
      fill: gradient.linear(
        self.colors.primary-dark,
        self.colors.primary.lighten(90%),
        angle: 90deg,
      ),
      width: 100%,
      height: 4pt,
    ),

    block(
      fill: self.colors.primary.lighten(90%),
      width: 100%,
      radius: (bottom: 6pt),
      inset: (top: 0.4em, bottom: 0.5em, left: 0.5em, right: 0.5em),
      it,
    ),
  )
}

#let tblock(title: none, it) = touying-fn-wrapper(_tblock.with(
  title: title,
  it,
))

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
        inset: (left: 1.5em, top: 1.2em, right: 1em),
        stack(
          dir: ttb,
          spacing: 0.55em,
          text(
            font: "Raleway",
            size: 28pt,
            fill: black,
            weight: "bold",
            info.title,
          ),
          ..info.authors.map(author => text(
            font: "Raleway",
            size: 20pt,
            fill: black,
            author,
          )),
        ),
      )
      if info.institution != none {
        v(0.45em)
        block(
          width: 100%,
          inset: (left: 1.5em, right: 1em),
          text(
            font: "Raleway",
            size: 16pt,
            fill: theme-gray,
            style: "italic",
            info.institution,
          ),
        )
      }
      if extra != none {
        v(0.45em)
        block(
          width: 100%,
          inset: (left: 1.5em, right: 1em),
          text(size: 0.8em, extra),
        )
      }
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
      self.store.align,
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
  align: horizon,
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
    block(width: 100%, inset: (bottom: 0.35em))[
      #std.align(right + bottom)[
        #utils.call-or-display(self, self.store.footer)
      ]
    ]
  }

  show: touying-slides.with(
    config-page(
      ..utils.page-args-from-aspect-ratio(aspect-ratio),
      header: header,
      footer: footer,
      header-ascent: 0em,
      footer-descent: 0.15em,
      margin: (top: 4.6em, bottom: 2em, x: 2.5em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(font: "Lato", size: 20pt, fill: rgb(89, 89, 89))
        set list(marker: components.knob-marker(primary: self.colors.primary))
        show figure.caption: set text(size: 0.6em)
        show footnote.entry: set text(size: 0.6em)
        show heading: set text(fill: self.colors.primary)
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
      primary: theme-gray,
      primary-dark: theme-gray-dark,
      secondary: rgb("#ffffff"),
      tertiary: theme-gray,
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
        fill: rgb(231, 230, 230),
        inset: (top: 0.45em, bottom: 0.45em),
      )[
        #set text(font: "Raleway", size: 17.8pt, fill: black)
        #std.align(left + horizon)[
          #left-navigation(
            self: self,
            primary: black,
            secondary: rgb("#666666"),
            background: rgb(231, 230, 230),
            logo: utils.call-or-display(self, self.store.header-right),
          )
        ]
      ],
      header: self => if self.store.title != none {
        block(
          width: 100%,
          inset: (left: 1.5em, top: 0.15em, bottom: 0.4em),
          text(
            font: "Raleway",
            fill: black,
            weight: "bold",
            size: 24pt,
            utils.call-or-display(self, self.store.title),
          ),
        )
      },
      footer: self => text(
        font: "Lato",
        size: 14pt,
        fill: rgb(89, 89, 89),
        context utils.slide-counter.display() + " / " + utils.last-slide-number,
      ),
    ),
    ..args,
  )

  body
}

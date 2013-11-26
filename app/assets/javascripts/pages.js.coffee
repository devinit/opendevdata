@startIntro = ->
  intro = introJs()
  intro.setOptions
    tooltipClass: "customDefault"
    steps: [
      element: document.querySelector("#step1")
      intro: "Welcome to Open Dev Data Uganda"
    ,
      element: document.querySelectorAll("#step2")[0]
      intro: "To look at all the datasets, click this link"
      position: "right"
    ]

  intro.start()

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#datasets').imagesLoaded ->
    $('#datasets').masonry
      itemSelector: '.box'
      isFitWidth: true

$ ->
  @startIntro = ->
    intro = introJs()
    intro.setOptions
      tooltipClass: "customDefault"
      steps: [
          element: document.querySelector("#form_step1")
          intro: "Fill in the name of your dataset"
        ,
          element: document.querySelectorAll("#form_step2")[0]
          intro: "Please provide a description of this dataset."
        ,
          element: "#form_step3"
          intro: "You must provide a title for your chart."
        ,
          element: "#form_step4"
          intro: "You must provide a subtitle; if none, type n/a."
        ,
          element: "#form_step5"
          intro: "The X-label defines the name of the \"x\" axis of your chart. It is optional."
        ,
          element: "#form_step6"
          intro: "The Y-label defines the name of the \"y\" axis of your chart. It is optional."
        ,
          element: "#form_step7"
          intro: "Data units are important; they tell us whether we are handling metrics. Use an appropriate metric such as kilos, milions, etc."
        ,
          element: "#form_step8"
          intro: "If you are working with a chart, please choose the type of chart from this list. Refer to the manual for the excel format to use."
        ,
          element: "#form_step9"
          intro: "Click this button to choose the location of your excel file."
        ,
          element: "#form_step10"
          intro: "Click this button to effect the changes you are adding."
          position: "right"
        ]

    intro.start()

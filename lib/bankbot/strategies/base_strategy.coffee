phantom = require 'phantom'

class BaseStrategy
  scripts:
    jQuery: "https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.4/jquery.min.js"

  driverOptions:
    parameters:
      'ssl-protocol': 'tlsv1'
      'ignore-ssl-errors': 'yes'

  open: (url, callback) ->
    @page.open @urls.login, (status) =>
      console.log "Page loaded, injecting scripts"
      @page.injectJs @scripts.jQuery, =>
        callback()

  fillForm: (formName, formData, submit, callback) ->
    console.log "filling in form - #{formName}"
    @page.evaluate ((formName, formData) ->
      $form = $("[name=#{formName}]")
      for key, value of formData
        $form.find("[name=#{key}]").val(value)
    ), =>
      if submit
        @submitForm(formName, callback)
      else
        callback()
    , formName, formData

  submitForm: (formName, callback) ->
    @capture()
    console.log "submitting form - #{formName}"
    @page.evaluate ((formName) ->
      $("form[name=#{formName}] input[name=submit]").click()
    ), =>
        @capture()
        callback()
    , formName

  capture: ->
    filename = new Date().toISOString()
    @page.render("capture/#{filename}.png")

  die: (error, details) ->
    console.log error
    console.log details if details?
    process.exit(1)

  ready: ->
    @die "What do expect me to do with this page... I am just the base strategy"

  validateTitle: (title, callback) ->
    @page.evaluate (-> document.title), (result) =>
      if result == title
        callback()
      else
        @die "The page seems to have changed", {
          expected: title
          got: result
        }

  setupErrorHandling: ->
    @page.set "onResourceError", (resourceError) ->
      console.log resourceError.errorString

    @page.set "onConsoleMessage", (error) ->
      console.log error

    @page.set "onResourceTimeout", (error) ->
      console.log error

    @page.set "onError", (error) ->
      # do nothing
      # console.log error

  constructor: ->
    phantom.create (ph) =>
      @ph = ph
      @ph.createPage (page) =>
        @page = page
        @setupErrorHandling()
        @ready()
    , @driverOptions

module.exports = BaseStrategy

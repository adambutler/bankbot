BaseStrategy = require './base_strategy'

class TescoCreditcard extends BaseStrategy
  urls:
    login: "https://www.tescobank.com/sss/authcc"

  login: ->
    console.log @urls.login
    @open @urls.login, =>
      @validateTitle "Welcome to your Tesco Credit Card online", =>
        @fillForm "UserLogonForm", {
          "uid": @config.username
        }, true, ->
          process.exit()

  ready: ->
    @login()

  constructor: (@config) ->
    super
    console.log "The TescoCreditcard strategy is ready"

module.exports = TescoCreditcard




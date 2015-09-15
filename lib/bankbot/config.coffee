Yml = require 'yml'

class Config
  die: (error) ->
    console.log error
    process.exit(1)

  validateConfig: ->

  loadConfigFile: ->
    try
      @configFile = Yml.load("./config.yml")
    catch e
      @die "Config can not be loaded"

  extractConfigArgument: ->
    process.argv[process.argv.length - 1]

  getBank: ->
    if @getConfig()["bank"]
      return @getConfig()["bank"]
    else
      @die "The bank name is undefined"

  getProduct: ->
    if @getConfig()["product"]
      return @getConfig()["product"]
    else
      @die "The product name is undefined"

  getStrategyId: ->
    "#{@getBank()}_#{@getProduct()}"

  getStrategy: ->
    return require("./strategies/#{@getStrategyId()}")

  isBankAndProductSupported: ->
    try
      @getStrategy()
    catch e
      @die "Sorry but #{@getBank()} / #{@getProduct()} is not supported yet"

  isValid: ->
    return false unless @configFile?
    return false unless @getConfig()?
    return false unless @isBankAndProductSupported()?
    return true

  getConfig: ->
    return @configFile[@extractConfigArgument()]

  constructor: ->
    @configFile = @loadConfigFile()
    return @

module.exports = Config

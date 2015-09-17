program = require "commander"
Yml = require 'yml'
Config = require './config'

class Cli
  constructor: ->
    config = new Config
    if config.isValid()
      Strategy = config.getStrategy()
      strategy = new Strategy(config.getConfig())

module.exports = Cli

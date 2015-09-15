BaseStrategy = require './base_strategy'

class TescoCreditcard extends BaseStrategy
  constructor: ->
    super
    console.log "The TescoCreditcard strategy is ready"

module.exports = TescoCreditcard

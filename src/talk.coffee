_ = require 'lodash'
request = require 'request'
config = require './config'
Client = require './client'
util = require './util'

class Talk

  constructor: (options = {}) ->
    @expire = Date.now()
    @init(options)

  init: (options) ->
    @options = _.extend(_.clone(config), options)
    return this

  discover: (version = 'v1', callback = ->) ->
    {apiHost, clientId, clientSecret} = @options
    params =
      clientId: clientId
      clientSecret: clientSecret
    reqOptions =
      method: 'GET'
      uri: apiHost + "/#{version}/discover"
      qs: params
    return callback(null, @client) if @client? and @expire > Date.now()
    util.request reqOptions, (err, result) =>
      @expire = Date.now() + 86400000
      @options.map = result if result?
      @client = new Client(@options)
      callback(err, @client)

talk = new Talk
talk.Talk = Talk
module.exports = talk

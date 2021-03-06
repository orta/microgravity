jade = require 'jade'
path = require 'path'
fs = require 'fs'
Backbone = require 'backbone'
{ fabricate } = require 'antigravity'
Artwork = require '../../../models/artwork'
SaleArtwork = require '../../../models/sale_artwork'
Sale = require '../../../models/sale'

render = (templateName) ->
  filename = path.resolve __dirname, "../templates/#{templateName}.jade"
  jade.compile(fs.readFileSync(filename), filename: filename)

describe 'Bid page template', ->

  it 'is fine for artworks without artists', ->
    render('bid_page')(
      saleArtwork: new SaleArtwork(fabricate 'sale_artwork')
      artwork: new Artwork(fabricate 'artwork', artist: null)
      auction: new Sale fabricate 'sale'
      sd: {}
      accounting: require('accounting')
    ).should.containEql 'Confirm your bid'

describe 'Register button', ->

  it 'should display register to bid if the user is not registered', ->
    it 'is fine for artworks without artists', ->
      render('bid_page')(
        saleArtwork: new SaleArtwork(fabricate 'sale_artwork')
        artwork: new Artwork(fabricate 'artwork', artist: null)
        auction: new Sale fabricate 'sale'
        registered: false
        sd: {}
        accounting: require('accounting')
      ).should.containEql 'Register to bid'

  it 'should display registration closed if registration_ends_at has passed', ->
    it 'is fine for artworks without artists', ->
      render('bid_page')(
        saleArtwork: new SaleArtwork(fabricate 'sale_artwork')
        artwork: new Artwork(fabricate 'artwork', artist: null)
        auction: new Sale fabricate 'sale', registration_ends_at: moment().subtract(2, 'days').format()
        registered: false
        sd: {}
        accounting: require('accounting')
      ).should.containEql 'Registration Closed'

  it 'should display registration closed if registration_ends_at has passed even if you are registered and qualified', ->
    it 'is fine for artworks without artists', ->
      render('bid_page')(
        saleArtwork: new SaleArtwork(fabricate 'sale_artwork')
        artwork: new Artwork(fabricate 'artwork', artist: null)
        auction: new Sale fabricate 'sale', registration_ends_at: moment().subtract(2, 'days').format()
        registered: true
        qualified: true
        sd: {}
        accounting: require('accounting')
      ).should.containEql 'Registration Closed'

  it 'should display registration pending if you are registered but not qualified', ->
    it 'is fine for artworks without artists', ->
      render('bid_page')(
        saleArtwork: new SaleArtwork(fabricate 'sale_artwork')
        artwork: new Artwork(fabricate 'artwork', artist: null)
        auction: new Sale fabricate 'sale', registration_ends_at: moment().subtract(2, 'days').format()
        registered: true
        qualified: false
        sd: {}
        accounting: require('accounting')
      ).should.containEql 'Registration Pending'

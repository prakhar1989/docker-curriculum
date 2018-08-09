var Metalsmith  = require('metalsmith');
var markdown    = require('metalsmith-markdown');
var layouts     = require('metalsmith-layouts');
var permalinks  = require('metalsmith-permalinks');
var metallic    = require('metalsmith-metallic');
var watch       = require('metalsmith-watch');

Metalsmith(__dirname)
  .metadata({
    title: "A Docker Tutorial for Beginners",
    description: "Learn to build and deploy your distributed applications easily to the cloud with Docker",
    author: "Prakhar Srivastav",
    url: "https://docker-curriculum.com/",
    logo: "https://docker-curriculum.com/images/logo-small.png",
  })
  .source('./src')
  .destination('./public')
  .clean(false)
  .use(metallic())
  .use(markdown())
  .use(permalinks())
  .use(layouts({
    engine: 'handlebars',
    partials: {
      analytics: 'partials/analytics',
      sw: 'partials/sw',
      meta: 'partials/meta',
      masthead: 'partials/masthead',
      nav: 'partials/nav',
    }
  }))
  .build(function(err, files) {
    if (err) { throw err; }
  });

--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith conf $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "index.md" $ do
        route $ setExtension "html"
        compile $ mdCompiler "index"

    match "pages/*.md" $ do
        route $ stripDir `composeRoutes` setExtension "html"
        compile $ mdCompiler "page"

    match "templates/*" $ compile templateBodyCompiler
--------------------------------------------------------------------------------

stripDir :: Routes
stripDir = gsubRoute "pages/" (const "")

mdCompiler css =
  pandocCompiler
  >>= loadAndApplyTemplate weddingTemplate ctx
  >>= relativizeUrls
  where weddingTemplate = "templates/wedding.html"
        ctx = defaultContext <> (field "stylesheet" $ const (return css))

conf :: Configuration
conf = defaultConfiguration {
  providerDirectory = "content"
  }


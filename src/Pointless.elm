
module Pointless exposing ( (~>) )

-- DOCS ------------------------------------------------------------------------

{-| TODO 

TODO: https://www.reddit.com/r/haskell/comments/ej646/composing_over_later_arguments/c18jgtz/
TODO: http://matt.immute.net/content/pointless-fun
TODO: http://conal.net/blog/posts/semantic-editor-combinators

@docs (~>)

-}


-- POINTLESS -------------------------------------------------------------------

infixr 2 ~>

{-| TODO 
-}
(~>) : (c -> d) -> ((a -> b) -> (b -> c) -> a -> d)
(~>) f g = (<<) f << (>>) g

infixl 2 <~

{-| TODO 
-}
(<~) : (a -> b) -> ((c -> d) -> (b -> c) -> a -> d)


module Pointless exposing ( (~>) )

-- DOCS ------------------------------------------------------------------------

{-| TODO 

@docs (~>)

-}


-- POINTLESS -------------------------------------------------------------------

infixr 2 ~>

{-| TODO 
-}
(~>) : (c -> d) -> (a -> b) -> (b -> c) -> a -> d
(~>) f g = (<<) f << (>>) g
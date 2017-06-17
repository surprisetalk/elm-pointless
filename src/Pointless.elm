
module Pointless exposing (    (~>)
                          ,   (-~>)
                          ,   (=~>)
                          ,   (~->)
                          ,  (-~->)
                          ,  (=~->)
                          ,   (|~>)
                          ,  (|-~>)
                          ,  (|=~>)
                          ,  (|~->)
                          , (|-~->)
                          , (|=~->)
                          )

-- DOCS ------------------------------------------------------------------------

{-| A pointless library to make more less-confusing point-free functions with pointy arrows.


# Flarg

The "flow-arg" combinator was inspired by [this post](http://matt.immute.net/content/pointless-fun).

The main principle is to take a function like this:

    f : a -> b -> c -> d

...and transform its arguments:

    g : i -> j -> k -> l
    g = f |~> a_to_i ~> b_to_j ~> c_to_k ~> d_to_l

If you're just using the main flarg operator, use `identity` to "skip" arguments:

    h : a -> j -> c -> d
    h = f |~> identity ~> b_to_j ~> identity ~> identity

You can omit extra arguments if you end with `identity`.

    h : a -> j -> c -> d
    h = f |~> identity ~> b_to_j ~> identity

You can pipe flarg-chains together:

    g : i -> j -> k -> l
    g = f |~> identity ~> b_to_y ~> c_to_k   ~> identity
          |~> a_to_i   ~> y_to_j ~> identity ~> d_to_l


@docs (~>)


# Nargs

Our "next-arg" combinators are useful for omitting arguments in your flarg-chain.

`-` represents one argument.
`=` represents two arguments.

Suppose you have a function.

    f : a -> b -> c -> d

To transform the first argument and the return value, you can use any of the following:

    g : i -> b -> c -> l
    g = f |~> a_to_i ~> identity ~> identity ~> d_to_l

    g : i -> b -> c -> l
    g = f |~> a_to_i ~> identity -~> d_to_l

    g : i -> b -> c -> l
    g = f |~> a_to_i -~> identity ~> d_to_l

    g : i -> b -> c -> l
    g = f |~> a_to_i =~> d_to_l


@docs (-~>), (=~>)


# Plargs

These operators are most useful as "plugs".

Flarg-chains will throw a compiler error unless one of the following three conditions is met:
- the number of arguments in the flarg-chain matches the target function
- the flarg-chain may prematurely end with `... ~> identity`
- the final member of the flarg-chain may be `... ~-> f`

So if you have a function:

    f : a -> b -> c -> d

...then the following are equivalent:

    g : i -> j -> c -> d
    g = f |~> a_to_i ~> b_to_j ~> identity ~> identity
        -- case 1: equal number of arguments

    g : i -> j -> c -> d
    g = f |~> a_to_i ~> b_to_j ~> identity
        -- case 2: end with `identity` and ignore the remaining arguments

    g : i -> j -> c -> d
    g = f |~> a_to_i ~-> b_to_j
        -- case 3: final flarg-chain operator is `~->`


@docs (~->), (-~->), (=~->)


# Bargs

"Begin" new flarg chains!

These operators are particularly useful for skipping the first argument(s).
They're also helpful when you only want to operate on the first, second, or third argument.

Consider the following function:

    f : a -> b -> c -> d

...then the following are equivalent:

    g : a -> j -> c -> d
    g = f |~> identity ~> b_to_j ~> identity ~> identity

    g : a -> j -> c -> d
    g = f |-~> b_to_j ~> identity ~> identity

    g : a -> j -> c -> d
    g = f |-~-> b_to_j


@docs (|~>), (|-~>), (|=~>), (|~->), (|-~->), (|=~->)


-}

-- PRECEDENCE ------------------------------------------------------------------

infixl 1 |~>
infixl 1 |-~>
infixl 1 |=~>
infixl 1 |~->
infixl 1 |-~->
infixl 1 |=~->

infixr 2 ~>
infixr 2 -~>
infixr 2 =~>
infixr 2 ~->
infixr 2 -~->
infixr 2 =~->


-- FLARG -----------------------------------------------------------------------

{-| Build a flarg-chain.

    g = f |~> transformA ~> transformB ~> transformC

For example, `List.repeat` is normally `Int -> a -> List a`, so let's make something like `List.repeat |~> ((Int -> Int)) ~> ((String -> String)) ~> ((List String -> String))`.

    repeatLoud : Int -> String -> String
    repeatLoud = List.repeat 
                 |~> (*) 2           
                  ~> String.toUpper
                  ~> String.join " "
    
    repeatLoud 2 "hey" == "HEY HEY HEY HEY"
    
-}
(~>) : (a -> a1) -> ((b -> c) -> (a1 -> b) -> a -> c)
(~>) f g = (>>) f << (<<) g


-- NARG ------------------------------------------------------------------------

{-| Skip an argument in your flarg-chain.

    --    f |~> transformA            -~> transformC
    -- == f |~> transformA ~> identity ~> transformC

    weirdRange : Int -> Int -> String
    weirdRange = List.range 
                 |~> flip (-) 3 
                  ~> identity 
                  ~> List.join ""

    weirdRange : Int -> Int -> String
    weirdRange = List.range 
                 |~> flip (-) 3 
                 -~> List.join ""

    weirdRange 4 7 == "1234567"

-}
(-~>) : (a -> a1) -> (b -> c) -> (a1 -> a2 -> b) -> a -> a2 -> c
(-~>) f g = f ~> identity ~> g



{-| Skip two arguments in your flarg-chain.

    --    f |~> transformA                        =~> transformD
    -- == f |~> transformA ~> identity ~> identity ~> transformD

    weirdSlice : Int -> Int -> String -> String
    weirdSlice = String.slice 
                 |~> (+) 1 
                  ~> identity 
                  ~> identity 
                  ~> String.reverse

    weirdSlice : Int -> Int -> String -> String
    weirdSlice = String.slice 
                 |~> (+) 1 
                 =~> String.reverse

    weirdSlice 0 -1 "HULLO" == "OLLU"

-}
(=~>) : (a -> a1) -> (b -> c) -> (a1 -> a2 -> a3 -> b) -> a -> a2 -> a3 -> c
(=~>) f g = f -~> identity ~> g


-- PLARG -----------------------------------------------------------------------

{-| Skip an argument in your flarg-chain *after* processing the next one. Useful for ending flarg-chains.

    --    f |~> transformA ~-> transformB
    -- == f |~> transformA  ~> transformB ~> identity

    repeatLoudFloat : Float -> String -> String
    repeatLoudFloat = String.repeat 
                      |~> floor 
                       ~> String.toUpper 
                       ~> identity

    repeatLoudFloat : Float -> String -> String
    repeatLoudFloat = String.repeat 
                      |~> floor 
                      ~-> String.toUpper

    repeatLoudFloat 3.14 "ha" == "HAHAHA"

-}
(~->) : (a -> a1) -> (a2 -> a1_1) -> (a1 -> a1_1 -> a3) -> a -> a2 -> a3
(~->) f g = f ~> g ~> identity


{-| Skip an argument in your flarg-chain *after* skipping and processing the next two. Useful for ending flarg-chains.

    --    f |~> transformA           -~-> transformC
    -- == f |~> transformA ~> identity ~> transformC ~> identity

    weirdDictSum : (Int -> v -> b -> b) -> b -> List ( Float, v ) -> b
    weirdDictSum = Dict.foldr 
                   |~> (>>) floor 
                    ~> identity 
                    ~> Dict.fromList 
                    ~> identity

    weirdDictSum : (Int -> v -> b -> b) -> b -> List ( Float, v ) -> b
    weirdDictSum = Dict.foldr 
                   |~> (>>) floor 
                  -~-> Dict.fromList

    weirdDictSum (\k v sum -> k + v + sum) 0 [(4.2,9),(93.9,8),(3.0,3)]

-}
(-~->) : (a -> a1) -> (a2 -> a1_1) -> (a1 -> a2_1 -> a1_1 -> a3) -> a -> a2_1 -> a2 -> a3
(-~->) f g = f -~> g ~> identity


{-| Skip an argument in your flarg-chain *after* skipping the next two and processing the third. Useful for ending flarg-chains.

    --    f |~> transformA                       =~-> transformD
    -- == f |~> transformA ~> identity ~> identity ~> transformD ~> identity

-}
(=~->) : (a -> a1) -> (a2 -> a1_1) -> (a1 -> a2_1 -> a3 -> a1_1 -> a4) -> a -> a2_1 -> a3 -> a2 -> a4
(=~->) f g = f =~> g ~> identity


-- BARGS -----------------------------------------------------------------------

{-| Start a flarg-chain.

This operator is identitical to `|>`. The reason this was included was to maintain conceptual consistency.

In this library, a tilde "~" before the arrow ">" indicates that it's going to parse the next argument.
The pipe "|" indicates that we're starting our flarg-chain.

-}
(|~>) : a -> (a -> b) -> b
(|~>) = (|>)


{-| Start a flarg-chain after skipping an argument.

    --    f |-~>            transformB
    -- == f |~> identity ~> transformB
     
    revecho : Int -> String -> String
    revecho = String.repeat 
              |-~> String.reverse 
                ~> (++) "echo: "

    revecho 3 "ah" == "echo: hahaha"

-}
(|-~>) : (a -> b) -> (b -> c) -> a -> c
(|-~>) f g = f |~> identity ~> g


{-| Start a flarg-chain after skipping two arguments.

    --    f |=~>                        transformC
    -- == f |~> identity ~> identity ~> transformC

-}
(|=~>) : (a -> a1 -> b) -> (b -> c) -> a -> a1 -> c
(|=~>) f g = f |-~> identity ~> g


{-| Start a flarg-chain, then end it after your first argument. Not that useful.

    --    f |~-> transformA
    -- == f |~>  transformA ~> identity

-}
(|~->) : (a1 -> a) -> (a2 -> a1) -> a2 -> a
(|~->) f g = f |~> g ~> identity


{-| Start a flarg-chain after skipping an argument, then end your chain.

    --    f |-~->           transformB
    -- == f |~> identity ~> transformB ~> identity

-}
(|-~->) : (a -> a1_1 -> a3) -> (a2 -> a1_1) -> a -> a2 -> a3
(|-~->) f g = f |~> identity ~-> g


{-| Start a flarg-chain after skipping two arguments, then end your chain.

    --    f |=~->                       transformC
    -- == f |~> identity ~> identity ~> transformC ~> identity

-}
(|=~->) : (a -> a1 -> a1_1 -> a3) -> (a2 -> a1_1) -> a -> a1 -> a2 -> a3
(|=~->) f g = f |-~> identity ~-> g

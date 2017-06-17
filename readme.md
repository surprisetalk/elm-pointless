
# Pointless

Transform function arguments with pointy operators.

Here's why I named this library "pointless":
- there's pointy arrows
- encourages more less-confusing [point-free]() functions
- this library is pointless


## Tutorial

BUG: this information is very errant

Suppose we have a function.

    a_to_b : a -> b

Also imagine we have some fun transformations that we want to apply to the *arguments*.

    x_to_a : x -> a
    y_to_b : y -> b
    z_to_c : z -> c

Now let's transform the argument `a` into `x`.

    x_to_b : x -> b
    x_to_b x = a_to_b (x_to_a x)

    x_to_b : x -> b
    x_to_b x = x_to_a x |> a_to_b

    x_to_b : x -> b
    x_to_b = x_to_a >> a_to_b

Easy! But what if our function has more variables?

    a_to_b_c : a -> b -> c

Yeesh. Now transforming `b` sounds like a bit of a pain.

    a_to_y_to_c : a -> y -> c
    a_to_y_to_c a y = a_to_b_to_c a (y_to_b y)

    a_to_y_to_c : a -> y -> c
    a_to_y_to_c a y = y_to_b y |> a_to_b_to_c a 

    a_to_y_to_c : a -> y -> c
    a_to_y_to_c a = y_to_b >> a_to_b_to_c a 

Not very intuitive. Let's do this with the "flarg" operator.

    a_to_y_to_c : a -> y -> c
    a_to_y_to_c = a_to_b_to_c |~> identity ~> y_to_b ~> identity

If you want, you can omit the last argument (hooray for currying!).

    a_to_y_to_c : a -> y -> c
    a_to_y_to_c = a_to_b_to_c |~> identity ~> y_to_b

Now let's do some more interesting stuff.

    x_to_y_to_z : x -> y -> z
    x_to_y_to_z = a_to_b_to_c |~> x_to_a ~> y_to_b ~> z_to_c

    x_to_b_to_z : x -> b -> z
    x_to_b_to_z = a_to_b_to_c |~> x_to_a ~> identity ~> z_to_c

You can even chain them together!

    x_to_y_to_z : x -> y -> z
    x_to_y_to_z = a_to_b_to_c 
               |~> identity ~> y_to_b   ~> identity
               |~> x_to_a   ~> identity ~> identity
               |~> identity ~> identity ~> z_to_c

Isn't this neat? As you've probably noticed, `identity` can be pretty cumbersome. Let's add some sugar.

Here's how you "skip" an argument using the "narg" operator.

    x_to_b_to_z : x -> b -> z
    x_to_b_to_z = a_to_b_to_c |~> x_to_a ~> identity ~> z_to_c

    x_to_b_to_z : x -> b -> z
    x_to_b_to_z = a_to_b_to_c |~> x_to_a ~*> z_to_c

And here's how you skip the first argument using the "barg" operator.

    a_to_y_to_z : a -> y -> z
    a_to_y_to_z = a_to_b_to_c |~> identity ~> y_to_b ~> z_to_c

    a_to_y_to_z : a -> y -> z
    a_to_y_to_z = a_to_b_to_c |*> y_to_b ~> z_to_c

You can also skip multiple arguments with operators like "snnarg" and "nnnnnarg"!

    a_to_b_to_z : a -> b -> z
    a_to_b_to_z = a_to_b_to_c |~> identity ~> identity ~> z_to_c

    a_to_b_to_z : a -> b -> z
    a_to_b_to_z = a_to_b_to_c |**> z_to_c

    p_to_b_to_c_to_s : p -> b -> c -> s
    p_to_b_to_c_to_s = a_to_b_to_c_d |~> p_to_a ~> identity ~> identity ~> s_to_d

    p_to_b_to_c_to_s : p -> b -> c -> s
    p_to_b_to_c_to_s = a_to_b_to_c_d |~> p_to_a ~> identity ~*> s_to_d

    p_to_b_to_c_to_s : p -> b -> c -> s
    p_to_b_to_c_to_s = a_to_b_to_c_d |~> p_to_a ~*> identity ~> s_to_d

    p_to_b_to_c_to_s : p -> b -> c -> s
    p_to_b_to_c_to_s = a_to_b_to_c_d |~> p_to_a ~**> s_to_d

Okay, so what does this look like in real-life?

TODO: real-life examples


## Inspiration

* https://www.reddit.com/r/haskell/comments/ej646/composing_over_later_arguments/c18jgtz/
  * http://matt.immute.net/content/pointless-fun
  * http://conal.net/blog/posts/semantic-editor-combinators


## Further Reading

* https://wiki.haskell.org/Pointfree

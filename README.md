Slug
==========

Slug generator for Erlang. Copied, modified and converted into a rebar library from the following gist:

https://gist.github.com/devinus/450612

Installation & Testing
======================

You will need:

* Erlang
* Rebar

Add slug.erl to your project's dependencies:

```erlang
{ deps, [
  { slug, ".*", { git, "git://github.com/wrren/slug.erl.git", { branch, "master" } } }
] }.
```

Pull project depedencies, compile and run unit tests.

```bash
rebar get-deps compile eunit
```

Usage
=====

Slug exposes one function: ```make```, which takes either one or two parameters. The first is the string
to be slugified and the second is an options proplist:

* ```{ lower, boolean() }``` - indicates whether upper-case letters should be converted to lower-case. Defaults to true.
* ```{ separator, char() }``` - specifies the separator character substituted when spaces or forward-slashes are encountered

Example
=======

```erlang

slug:make( "Hello World" )  					%% "hello-world"
slug:make( "Hello World", [{ lower, false }] )  %% "Hello-World"
slug:make( "Hello_World" )  					%% "hello_world"
slug:make( "Hello/World" )  					%% "hello-world"
slug:make( "Hello?World" )  					%% "helloworld"
slug:make( "Hello?World-Foo" )  				%% "helloworld-foo"
slug:make( "Hello World", [{ separator, $_ }] ) %% "hello_world"
slug:make( "Hello-World" )  					%% "hello-world"

```


 USING: kernel continuations sequences namespaces fry ;

 IN: backtrack

 SYMBOL: failure 

 : amb ( seq -- elt )
        failure get
        '[ , _ '[ , '[ failure set , , continue-with ] callcc0 ] each
                , continue ] callcc1 ;


(define (domain Dungeon)

    (:requirements
        :typing
        :negative-preconditions
        :conditional-effects
    )

    ; Do not modify the types
    (:types
        location colour key corridor
    )

    ; Do not modify the constants
    (:constants
        red yellow green purple rainbow - colour
    )

    ; You may introduce whatever predicates you would like to use
    (:predicates

        ; One predicate given for free!
        ; Hero predicates
        (hero-at ?loc - location)
        (arm-free)
        (has-key ?k - key)

        ; Corridor predicates 
        (locked ?cor - corridor ?col - colour)
        (unlocked ?cor - corridor)
        (is-risky ?cor - corridor)
        (corr-exist ?cor - corridor ?loc -location) 

        ; Key predicates
        (key-at ?loc - location ?key - key)
        (one-use ?k - key)
        (two-use ?k - key)
        (no-use ?k - key)
        (key-colour ?k - key ?col - colour)
        
    )

    ; IMPORTANT: You should not change/add/remove the action names or parameters

    ;Hero can move if the
    ;    - hero is at current location ?from,
    ;    - wants to move to location ?to,
    ;    - corridor ?cor exists between the ?from and ?to locations
    ;    - there isn't a locked door in corridor ?cor
    ;Effects move the hero, and collapse the corridor if it's "risky"
    (:action move

        :parameters (?from ?to - location ?cor - corridor)

        :precondition (and
            (hero-at ?from) 
            (corr-exist ?cor ?from)
            (corr-exist ?cor ?to)
            (unlocked ?cor)
        )

        :effect (and
            (when (is-risky ?cor) (and (not (corr-exist ?cor ?from)) (not (corr-exist ?cor ?to))))
            (hero-at ?to)
            (not(hero-at ?from))
        )
    )

    ;Hero can pick up a key if the
    ;    - hero is at current location ?loc,
    ;    - there is a key ?k at location ?loc,
    ;    - the hero's arm is free,
    ;Effect will have the hero holding the key and their arm no longer being free
    (:action pick-up

        :parameters (?loc - location ?k - key)

        :precondition (and
        (hero-at ?loc)
        (key-at ?loc ?k)
        (arm-free)
        )

        :effect (and
            (not (key-at ?loc ?k)) 
            (has-key ?k)
            (not(arm-free))
        )
    )

    ;Hero can drop a key if the
    ;    - hero is holding a key ?k,
    ;    - the hero is at location ?loc
    ;Effect will be that the hero is no longer holding the key
    (:action drop

        :parameters (?loc - location ?k - key)

        :precondition (and
            (has-key ?k)
            (hero-at ?loc)
            (not(arm-free))
        )

        :effect (and
            (not(has-key ?k))
            (key-at ?loc ?k)
            (arm-free) 
        )
    )


    ;Hero can use a key for a corridor if
    ;    - the hero is holding a key ?k,
    ;    - the key still has some uses left,
    ;    - the corridor ?cor is locked with colour ?col,
    ;    - the key ?k is if the right colour ?col,
    ;    - the hero is at location ?loc
    ;    - the corridor is connected to the location ?loc
    ;Effect will be that the corridor is unlocked and the key usage will be updated if necessary
    (:action unlock

        :parameters (?loc - location ?cor - corridor ?col - colour ?k - key)

        :precondition (and
            (hero-at ?loc)
            (has-key ?k)
            (locked ?cor ?col)
            (corr-exist ?cor ?loc)
            (not(no-use ?k)) 
            (key-colour ?k ?col)
        )  

        :effect (and
            (unlocked ?cor)
            (when (one-use ?k) (no-use ?k))
            (when (two-use ?k) (one-use ?k))
        )
    )

)

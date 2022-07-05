---------- MODULE wire --------
EXTENDS Integers
(*--algorithm wire
    variables
        people = {"alice", "bob"}, \* set
        acc = [p \in people |-> 5], \* function - For each value in a given set, it
\*maps to some output value (here to 5)
        sender = "alice",
        receiver = "bob",
        amount = 3;
        
define
    NoOverdrafts == \A p \in people: acc[p] >= 0 \* Invariant" for all p in the set of people, their account must be greater
\*than or equal to 0
end define;

begin
    skip;
end algorithm;*)
===============================
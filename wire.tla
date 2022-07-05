---------- MODULE wire --------
EXTENDS Integers
(*--algorithm wire
    variables
        \* set
        people = {"alice", "bob"}, 
        \* function - For each value in a given set, it maps to some output value (here to 5)
        acc = [p \in people |-> 5], 
        sender = "alice",
        receiver = "bob",
        amount = 3;
        
define
    \* Invariant" for all p in the set of people, their account must be greater than or equal to 0
    NoOverdrafts == \A p \in people: acc[p] >= 0 
end define;

begin
    Withdraw: \* label - everything inside it happens in the same moment of time
        \* if the variable already exists and you assign a new value to it, you use :=
        acc[sender] := acc[sender] - amount;
    Deposit:
        acc[receiver] := acc[receiver] + amount;
end algorithm;*)
\* BEGIN TRANSLATION (chksum(pcal) = "ed73f16c" /\ chksum(tla) = "f067a8a0")
VARIABLES people, acc, sender, receiver, amount, pc

(* define statement *)
NoOverdrafts == \A p \in people: acc[p] >= 0


vars == << people, acc, sender, receiver, amount, pc >>

Init == (* Global variables *)
        /\ people = {"alice", "bob"}
        /\ acc = [p \in people |-> 5]
        /\ sender = "alice"
        /\ receiver = "bob"
        /\ amount = 3
        /\ pc = "Withdraw"

Withdraw == /\ pc = "Withdraw"
            /\ acc' = [acc EXCEPT ![sender] = acc[sender] - amount]
            /\ pc' = "Deposit"
            /\ UNCHANGED << people, sender, receiver, amount >>

Deposit == /\ pc = "Deposit"
           /\ acc' = [acc EXCEPT ![receiver] = acc[receiver] + amount]
           /\ pc' = "Done"
           /\ UNCHANGED << people, sender, receiver, amount >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Withdraw \/ Deposit
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
===============================

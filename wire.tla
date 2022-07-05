---------- MODULE wire --------
EXTENDS Integers
(*--algorithm wire
    variables
        \* set
        people = {"alice", "bob"}, 
        \* function - For each value in a given set, it maps to some output value (here to 5)
        acc = [p \in people |-> 5], 
        
define
    \* Invariant" for all p in the set of people, their account must be greater than or equal to 0
    NoOverdrafts == \A p \in people: acc[p] >= 0 
end define;

\* In PlusCal, each algorithm happening simultaneously belongs to its own process. 
\* Each process can have its own code and its own local variables.
process Wire \in 1..2
    variables
        sender = "alice",
        receiver = "bob",
        amount \in 1..acc[sender];

begin
    \* the check and withdraw in the same label
    CheckAndWithdraw: \* check and withdraw happen in the same moment of time
        if amount <= acc[sender] then
                \* if the variable already exists and you assign a new value to it, you use :=
                acc[sender] := acc[sender] - amount;
            Deposit:
                acc[receiver] := acc[receiver] + amount;
        end if;
end process; 
end algorithm;*)
\* BEGIN TRANSLATION (chksum(pcal) = "c4d5e088" /\ chksum(tla) = "8c3a95ed")
VARIABLES people, acc, pc

(* define statement *)
NoOverdrafts == \A p \in people: acc[p] >= 0

VARIABLES sender, receiver, amount

vars == << people, acc, pc, sender, receiver, amount >>

ProcSet == (1..2)

Init == (* Global variables *)
        /\ people = {"alice", "bob"}
        /\ acc = [p \in people |-> 5]
        (* Process Wire *)
        /\ sender = [self \in 1..2 |-> "alice"]
        /\ receiver = [self \in 1..2 |-> "bob"]
        /\ amount \in [1..2 -> 1..acc[sender[CHOOSE self \in  1..2 : TRUE]]]
        /\ pc = [self \in ProcSet |-> "CheckAndWithdraw"]

CheckAndWithdraw(self) == /\ pc[self] = "CheckAndWithdraw"
                          /\ IF amount[self] <= acc[sender[self]]
                                THEN /\ acc' = [acc EXCEPT ![sender[self]] = acc[sender[self]] - amount[self]]
                                     /\ pc' = [pc EXCEPT ![self] = "Deposit"]
                                ELSE /\ pc' = [pc EXCEPT ![self] = "Done"]
                                     /\ acc' = acc
                          /\ UNCHANGED << people, sender, receiver, amount >>

Deposit(self) == /\ pc[self] = "Deposit"
                 /\ acc' = [acc EXCEPT ![receiver[self]] = acc[receiver[self]] + amount[self]]
                 /\ pc' = [pc EXCEPT ![self] = "Done"]
                 /\ UNCHANGED << people, sender, receiver, amount >>

Wire(self) == CheckAndWithdraw(self) \/ Deposit(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in 1..2: Wire(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
===============================

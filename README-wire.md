Alice and Bob have accounts at Bankgroup. Each account has 0 or more dollars in it.
Bankgroup wants to add a new “wire” feature, where any user can transfer money to any
other user. This feature has the following requirements:

• Each wire must be between two different people in the bank and wire
at least one dollar.
• If a wire is successful, the value of the wire is deducted from the
sender account and added to the receiver account.
• If the wire fails, the two accounts are unchanged.
• A wire may not cause an account to have a negative balance.
• For scaling reasons, multiple wires may happen simultaneously.
# Define Profile node
node Profile {
    has username: str = "";

    # Declare update ability
    can update with update_profile entry;

}

# Define Tweet node
node Tweet {
    has content: str;  
}

# Define Comment node
node Comment {
    has content: str;
}

# Define Post edge
edge Post { }

# Define create profile
walker create_profile {
    has username: str;

    # Declare create ability
    can create with `root entry;
}

# Define update profile
walker update_profile { 
    has new_username: str;
}

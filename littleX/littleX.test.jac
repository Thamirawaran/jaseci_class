# Test create ability
test create_profile_walker {
    root spawn create_profile("Elon");
   	profile = [root --> (`?Profile)][0];
    check isinstance(profile,Profile);
    check profile.username == "Elon";
}

# Test update ability
test update_profile_walker {
    profile = [root --> (`?Profile)][0];
   	profile spawn update_profile("Musk");
	check profile.username == "Musk";
}

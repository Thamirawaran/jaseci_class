# Define create ability
impl create_profile.create {
	if not [here --> (`?Profile)] {
		here ++> Profile(self.username);
	}

    report [here --> (`?Profile)];
	# if  not [root –>  (`?Profile)] {
	# 	root ++> Profile(self.username);
	# }
}


# Define update ability
impl Profile.update {
	self.username = visitor.new_username;
    report self;
}

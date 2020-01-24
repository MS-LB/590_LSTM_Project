
menu_item = 1
while menu_item != 0:

    name = raw_input("name:")
    screen_name = raw_input("screen_name:")
    party = raw_input("party  r/d:")
    incumbent = raw_input("incumbent y/n: ")
    state = raw_input("state (lowercase):")
    outcome = raw_input("election outcome w/l:")
    percent = raw_input("percent:")
    type_of_office = raw_input("type_of_office (s/l or state/local):")
    name_of_office = raw_input(
        "name_of_office\r\nEx: state_senator\r\n    state_representative\r\n    us_senator\r\n    us_representative\r\n    governor\r\n    lieutenant_governor\r\ninput here:")

    if party == 'r':
        party_bool = 1
    else:
        party_bool = 0

    if incumbent == 'y':
        incumbent_bool = 1
    else:
        incumbent_bool = 0

    if outcome == 'w':
        outcome_bool = 1
    else:
        outcome_bool = 0

    if type_of_office == 's' or type_of_office == 'state':
        type_of_office_bool = 1
    else:
        type_of_office_bool = 0

    # bug when restarting without deleting the file the first new ...must add \n on first write
    # write:name, scree_name, party_bool, incumbent_bool, state
    firstWrite = True
    new_line = name + "," + screen_name + "," + str(party_bool) + "," + str(
        incumbent_bool) + "," + state + "," + str(outcome_bool) + "," + str(percent) + "," + str(
        type_of_office_bool) + "," + name_of_office + "\r\n"

    if firstWrite:
        firstWrite = False
        new_line = "\r\n" + name + "," + screen_name + "," + str(party_bool) + "," + str(
            incumbent_bool) + "," + state + "," + str(outcome_bool) + "," + str(percent) + "," + str(
            type_of_office_bool) + "," + name_of_office + "\r\n"

    with open("Candidates.txt", "a+") as can_file:
        can_file.write(new_line)

    menu_item = raw_input("Menu\r\n1. Continue\r\n2. Quit\r\n")
    if int(menu_item) == 2:
        exit()
    else:
        menu_item = 1

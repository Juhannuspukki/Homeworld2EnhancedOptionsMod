# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.

file_start = 'PersistantData = {\n    StrikeGroups = {},\n    Squadrons = {\n'
file_end = '    },\n    Research = {},\n}'
indent = "        "

# resource collector numbers
collector_amounts = ["00", "03", "06", "09", "12", "15"]

refinery_amounts = ["00", "01", "02"]

progenitor_options = ["0", "1", "2", "3"]

race_shorthand = {"Hiigaran": "Hgn", "Vaygr": "Vgr"}


def create_amount(n): return '", subsystems = {}, shiphold = {}, name = "", size = 1, number = ' + str(int(n)) + '},\n'


def mothership(n, race): return '{type = "' + race + '_MotherShip' + create_amount(n)


def carrier(n, race): return '{type = "' + race + '_Carrier' + create_amount(n)


def shipyard(n, race): return '{type = "' + race + '_Shipyard' + create_amount(n)


def resourcecollector(n, race): return '{type = "' + race + '_ResourceCollector' + create_amount(n)


def resourcecontroller(n, race): return '{type = "' + race + '_ResourceController' + create_amount(n)


def dreadnaught(n): return '{type = "Hgn_Dreadnaught' + create_amount(n)


def sajuuk(n): return '{type = "Kpr_Sajuuk' + create_amount(n)


def filename(race, name, collectors, refineries, progenitors):
    string = race + "00"
    if name:
        string += "+name=" + name
    if collectors:
        string += "+collectors=" + collectors
    if refineries:
        string += "+refineries=" + refineries
    if progenitors:
        string += "+progenitors=" + progenitors
    string += ".lua"
    return string


def create_fleet(race, name, ships):
    shorthand = race_shorthand[race]
    for progenitors in progenitor_options:
        for refineries in refinery_amounts:
            for collectors in collector_amounts:
                fleet = file_start
                for ship in ships:
                    fleet += indent + ship
                if collectors != "00":
                    fleet += indent + resourcecollector(collectors, shorthand)
                if refineries != "00":
                    fleet += indent + resourcecontroller(refineries, shorthand)
                if progenitors == "1":
                    fleet += indent + dreadnaught("1")
                if progenitors == "2":
                    fleet += indent + sajuuk("1")
                if progenitors == "3":
                    fleet += indent + dreadnaught("1")
                    fleet += indent + sajuuk("1")
                fleet += file_end
                f = open(filename(race, name, collectors, refineries, progenitors), "w")
                f.write(fleet)
                f.close()


def create_fleets(race):
    shorthand = race_shorthand[race]
    create_fleet(race, "mothership", [mothership("1", shorthand)])
    create_fleet(race, "shipyard", [shipyard("1", shorthand)])
    create_fleet(race, "default", [mothership("1", shorthand), carrier("1", shorthand)])
    create_fleet(race, "carriers", [carrier("2", shorthand)])
    create_fleet(race, "defaultAndShipyard", [mothership("1", shorthand), carrier("1", shorthand), shipyard("1", shorthand)])
    create_fleet(race, "shipyardAndCarrier", [carrier("1", shorthand), shipyard("1", shorthand)])


def generate_files():
    # Use a breakpoint in the code line below to debug your script.
    create_fleets("Hiigaran")
    create_fleets("Vaygr")


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    generate_files()

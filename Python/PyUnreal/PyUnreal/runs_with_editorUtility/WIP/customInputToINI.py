
import ConfigParser 

config = COnfigParser.RawConfigParser()

config.add_section('Path')
brought_path = input()
config.add_section('Path','dir',brought_path)


with open('example.cfg', 'wb') as configfile:
    config.write(configfile)
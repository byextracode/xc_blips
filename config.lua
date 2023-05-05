Config  = {}

Config.ox_lib = false -- use ox_lib, if true don't forget to load ox_lib in resource manifest
Config.tickupdate = 5 -- time to update the blips from server in seconds (performance matters)
Config.playersupdate = 60 -- time to update/fetch players data from server in seconds (performance matters)

Config.Sprite = {
    [0] = {sprite = 225},
    [1] = {sprite = 225},
    [2] = {sprite = 225},
    [3] = {sprite = 225},
    [4] = {sprite = 225},
    [5] = {sprite = 225},
    [6] = {sprite = 225},
    [7] = {sprite = 523},
    [8] = {sprite = 226},
    [9] = {sprite = 225},
    [10] = {sprite = 67},
    [11] = {sprite = 67},
    [12] = {sprite = 67},
    [13] = {sprite = 226},
    [14] = {sprite = 410},
    [15] = {sprite = 422},
    [16] = {sprite = 423},
    [17] = {sprite = 225},
    [18] = {sprite = 672},
    [19] = {sprite = 225},
    [20] = {sprite = 67},
    [22] = {sprite = 1},
}

Config.authorizedJob = {
    police = {                  -- main job name
        color = 26,             -- blip color id
        sharedjobs = {          -- job that authorized to see the current blips
            police = true,
        }
    },
    ambulance = {
        color = 1,
        sharedjobs = {
            ambulance = true,
            police = true, -- this means police job can also see ambulance blips
        }
    },
    mechanic = {
        color = 31,
        sharedjobs = {
            mechanic = true,
        }
    },
}

tableData = { -- authorized job data, see Config.authorizedJob
    police = {},
    ambulance = {},
    mechanic = {}
}
global stagingRocket TO FALSE.
function main {
    launchStart().
    print "Lift Off!".
    ascentGuidance().
    until apoapsis > 90000 {
        PRINT "Monitoring Ascent Staging...".
        
        ascentStaging().
    }
    // circularizationBurn().
    // spacecraftConfigManeuver().
    // munarTransferBurn().
    // munarOrbitalBurn().
}

function launchStart {
    sas OFF.
    print "Guidance Internal".
    lock throttle to 1.
    for i in range(0,5){
        print "Countdown: " + (5 - i).
        wait 1.
    }
    print "All systems go.".
    stageRocket("Launch").
}

function stageRocket {
    parameter stageName.

    wait until stage:ready.
    SET stagingRocket TO TRUE.
    PRINT "Staging " + stageName + "...".
    stage.
    SET stagingRocket TO FALSE.
}

function ascentGuidance {
    PRINT "Ascent Guidance Operational...".
    lock targetPitch to 88.963 - 1.03287 * alt:radar^0.409511.
    // lets try nat. log (e ^ 2)
    //lock targetPitch to alt:radar * constant:e ^ 2.
    lock steering to heading(90, targetPitch).
}

function ascentStaging {
    if not(defined oldThrust) {
        global oldThrust is ship:availablethrust.
    }
    if ship:availablethrust < (oldThrust - 10) {
        until false {
            stageRocket("Rocket"). wait 1.
            // abortSystemMonitor().
            if ship:availableThrust > 0 { 
            break.
            }
        }
        global oldThrust is ship:availablethrust.
    }
}

main().
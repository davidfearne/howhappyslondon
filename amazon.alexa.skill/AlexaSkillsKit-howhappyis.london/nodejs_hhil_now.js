var https = require('https')

exports.handler = (event, context) => {

  try {

    if (event.session.new) {
      // New Session
      console.log("NEW SESSION")
    }

    switch (event.request.type) {

      case "LaunchRequest":
        // Launch Request
        console.log(`LAUNCH REQUEST`)
        context.succeed(
          generateResponse(
            buildSpeechletResponse("Welcome to the how happy is London Alexa skill, now ask me how happy London is now or over the last month", true),
            {}
          )
        )
        break;

      case "IntentRequest":
        // Intent Request
        console.log(`INTENT REQUEST`) //logging the intent that has been actived

        switch(event.request.intent.name) {
          case "getHappinessOfLondonNow":
            var endpoint = "https://api.arrowdemo.center/v1/theface/now"
            var body = ""
            https.get(endpoint, (response) => {
              response.on('data', (chunk) => { body += chunk })
              response.on('end', () => {
                var data = JSON.parse(body)
                var currentHappiness = data.value
                context.succeed(
                  generateResponse(
                    buildSpeechletResponse(`Current happiness of London is ${currentHappiness}`, true),
                    {}
                  )
                )
              })
            })
            break;
            
             case "getHappinessOfLondonLastMonth":
            var endpoint = "https://api.arrowdemo.center/v1/theface/sum"
            var body = ""
            https.get(endpoint, (response) => {
              response.on('data', (chunk) => { body += chunk })
              response.on('end', () => {
                var data = JSON.parse(body)
                var sumIndex = data.index
                var sumValue = data.value
                context.succeed(
                  generateResponse(
                    buildSpeechletResponse(`last month London was mostly ${sumValue} with an average index of ${sumIndex} percent`, true),
                    {}
                  )
                )
              })
            })
            break;

          default:
            throw "Invalid intent"
        }

        break;

      case "SessionEndedRequest":
        // Session Ended Request
        console.log(`SESSION ENDED REQUEST`)
        break;

      default:
        context.fail(`INVALID REQUEST TYPE: ${event.request.type}`)

    }

  } catch(error) { context.fail(`Exception: ${error}`) }

}

// Helpers
buildSpeechletResponse = (outputText, shouldEndSession) => {

  return {
    outputSpeech: {
      type: "PlainText",
      text: outputText
    },
    shouldEndSession: shouldEndSession
  }

}

generateResponse = (speechletResponse, sessionAttributes) => {

  return {
    version: "1.0",
    sessionAttributes: sessionAttributes,
    response: speechletResponse
  }

}
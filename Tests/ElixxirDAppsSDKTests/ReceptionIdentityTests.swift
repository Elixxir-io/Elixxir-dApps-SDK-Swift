import CustomDump
import XCTest
@testable import ElixxirDAppsSDK

final class ReceptionIdentityTests: XCTestCase {
  func testCoding() throws {
    let idString = "emV6aW1hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD"
    let rsaPrivatePemString = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcFFJQkFBS0NBUUVBNU15dTdhYjBJOS9UL1BFUUxtd2x3ejZHV3FjMUNYemVIVXhoVEc4bmg1WWRWSXMxCmJ2THpBVjNOMDJxdXN6K2s4TVFEWjBtejMzdkswUmhPczZIY0NUSFdzTEpXRkE5WWpzWWlCRi9qTDd1bmd1ckIKL2tvK1JJSnNrWGFWaEZaazRGdERoRXhTNWY4RnR0Qmk1NmNLZmdJQlVKT3ozZi9qQllTMkxzMlJ6cWV5YXM3SApjV2RaME9TclBTT3BiYlViU1FPbS9LWnlweGZHU21yZ2oxRUZuU1dZZ2xGZTdUOTRPbHF5MG14QTV5clVXbHorCk9sK3hHbXpCNUp4WUFSMU9oMFQrQTk4RWMrTUZHNm43L1MraDdzRDgybGRnVnJmbStFTzRCdmFKeTRESGZGMWgKNnp6QnVnY25NUVFGc0dLeDFYWC9COTVMdUpPVjdyeXlDbzZGbHdJREFRQUJBb0lCQVFDaUh6OGNlcDZvQk9RTAphUzBVRitHeU5VMnlVcVRNTWtTWThoUkh1c09CMmFheXoybHZVb3RLUHBPbjZRSWRWVTJrcE4vY2dtY0lSb2x5CkhBMDRUOHJBWVNaRlVqaVlRajkzKzRFREpJYXd2Z0YyVEs1bFoyb3oxVTdreStncU82V0RMR2Z0Q0wvODVQWEIKa210aXhnUXpRV3g1RWcvemtHdm03eURBalQxeDloNytsRjJwNFlBam5kT2xTS0dmQjFZeTR1RXBQd0kwc1lWdgpKQWc0MEFxbllZUmt4emJPbmQxWGNjdEJFN2Z1VDdrWXhoeSs3WXYrUTJwVy9BYmh6NGlHOEY1MW9GMGZwV0czCmlISDhsVXZFTkp2SUZEVHZ0UEpESlFZalBRN3lUbGlGZUdrMXZUQkcyQkpQNExzVzhpbDZOeUFuRktaY1hOQ24KeHVCendiSlJBb0dCQVBUK0dGTVJGRHRHZVl6NmwzZmg3UjJ0MlhrMysvUmpvR3BDUWREWDhYNERqR1pVd1RGVQpOS2tQTTNjS29ia2RBYlBDb3FpL0tOOVBibk9QVlZ3R3JkSE9vSnNibFVHYmJGamFTUzJQMFZnNUVhTC9rT2dUCmxMMUdoVFpIUWk1VUlMM0p4M1Z3T0ZRQ3RQOU1UQlQ0UEQvcEFLbDg3VTJXN3JTY1dGV1ZGbFNkQW9HQkFPOFUKVmhHWkRpVGFKTWVtSGZIdVYrNmtzaUlsam9aUVVzeGpmTGNMZ2NjV2RmTHBqS0ZWTzJNN3NqcEJEZ0w4NmFnegorVk14ZkQzZ1l0SmNWN01aMVcwNlZ6TlNVTHh3a1dRY1hXUWdDaXc5elpyYlhCUmZRNUVjMFBlblVoWWVwVzF5CkpkTC8rSlpQeDJxSzVrQytiWU5EdmxlNWdpcjlDSGVzTlR5enVyckRBb0dCQUl0cTJnN1RaazhCSVFUUVNrZ24Kb3BkRUtzRW4wZExXcXlBdENtVTlyaWpHL2l2eHlXczMveXZDQWNpWm5VVEp0QUZISHVlbXVTeXplQ2g5QmRkegoyWkRPNUdqQVBxVHlQS3NudFlNZkY4UDczZ1NES1VSWWVFbHFDejdET0c5QzRzcitPK3FoN1B3cCtqUmFoK1ZiCkNuWllNMDlBVDQ3YStJYUJmbWRkaXpLbEFvR0JBSmo1dkRDNmJIQnNISWlhNUNJL1RZaG5YWXUzMkVCYytQM0sKMHF3VThzOCtzZTNpUHBla2Y4RjVHd3RuUU4zc2tsMk1GQWFGYldmeVFZazBpUEVTb0p1cGJzNXA1enNNRkJ1bwpncUZrVnQ0RUZhRDJweTVwM2tQbDJsZjhlZXVwWkZScGE0WmRQdVIrMjZ4eWYrNEJhdlZJeld3NFNPL1V4Q3crCnhqbTNEczRkQW9HQWREL0VOa1BjU004c1BCM3JSWW9MQ2twcUV2U0MzbVZSbjNJd3c1WFAwcDRRVndhRmR1ckMKYUhtSE1EekNrNEUvb0haQVhFdGZ2S2tRaUI4MXVYM2c1aVo4amdYUVhXUHRteTVIcVVhcWJYUTlENkxWc3B0egpKL3R4SWJLMXp5c1o2bk9IY1VoUUwyVVF6SlBBRThZNDdjYzVzTThEN3kwZjJ0QURTQUZNMmN3PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQ=="
    let saltString = "4kk02v0NIcGtlobZ/xkxqWz8uH/ams/gjvQm14QT0dI="
    let dhKeyPrivateString = "eyJWYWx1ZSI6NDU2MDgzOTEzMjA0OTIyODA5Njg2MDI3MzQ0MzM3OTA0MzAyODYwMjM2NDk2NDM5NDI4NTcxMTMwNDMzOTQwMzgyMTIyMjY4OTQzNTMyMjIyMzc1MTkzNTEzMjU4MjA4MDA0NTczMDY4MjEwNzg2NDI5NjA1MjA0OTA3MjI2ODI5OTc3NTczMDkxODY0NTY3NDExMDExNjQxNCwiRmluZ2VycHJpbnQiOjE2ODAxNTQxNTExMjMzMDk4MzYzfQ=="
    let jsonString = """
    {
      "ID": "\(idString)",
      "RSAPrivatePem": "\(rsaPrivatePemString)",
      "Salt": "\(saltString)",
      "DHKeyPrivate": "\(dhKeyPrivateString)"
    }
    """
    let jsonData = jsonString.data(using: .utf8)!

    let identity = try ReceptionIdentity.decode(jsonData)

    XCTAssertNoDifference(identity, ReceptionIdentity(
      id: Data(base64Encoded: idString)!,
      rsaPrivatePem: Data(base64Encoded: rsaPrivatePemString)!,
      salt: Data(base64Encoded: saltString)!,
      dhKeyPrivate: Data(base64Encoded: dhKeyPrivateString)!
    ))

    let encodedIdentity = try identity.encode()
    let decodedIdentity = try ReceptionIdentity.decode(encodedIdentity)

    XCTAssertNoDifference(decodedIdentity, identity)
  }
}

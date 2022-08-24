import ComposableArchitecture
import SwiftUI

public struct RegisterView: View {
  public init(store: Store<RegisterState, RegisterAction>) {
    self.store = store
  }

  let store: Store<RegisterState, RegisterAction>
  @FocusState var focusedField: RegisterState.Field?

  struct ViewState: Equatable {
    init(_ state: RegisterState) {
      focusedField = state.focusedField
      username = state.username
      isRegistering = state.isRegistering
      failure = state.failure
    }

    var focusedField: RegisterState.Field?
    var username: String
    var isRegistering: Bool
    var failure: String?
  }

  public var body: some View {
    WithViewStore(store.scope(state: ViewState.init)) { viewStore in
      NavigationView {
        Form {
          Section {
            TextField(
              text: viewStore.binding(
                get: \.username,
                send: { RegisterAction.set(\.$username, $0) }
              ),
              prompt: Text("Enter username"),
              label: { Text("Username") }
            )
            .focused($focusedField, equals: .username)
          } header: {
            Text("Username")
          }

          Section {
            Button {
              viewStore.send(.registerTapped)
            } label: {
              HStack {
                if viewStore.isRegistering {
                  ProgressView().padding(.trailing)
                  Text("Registering...")
                } else {
                  Text("Register")
                }
              }
              .frame(maxWidth: .infinity)
            }
          }

          if let failure = viewStore.failure {
            Section {
              Text(failure)
            } header: {
              Text("Error").foregroundColor(.red)
            }
          }
        }
        .disabled(viewStore.isRegistering)
        .navigationTitle("Register")
        .onChange(of: viewStore.focusedField) { focusedField = $0 }
        .onChange(of: focusedField) { viewStore.send(.set(\.$focusedField, $0)) }
      }
    }
  }
}

#if DEBUG
public struct RegisterView_Previews: PreviewProvider {
  public static var previews: some View {
    RegisterView(store: Store(
      initialState: RegisterState(),
      reducer: .empty,
      environment: ()
    ))
  }
}
#endif
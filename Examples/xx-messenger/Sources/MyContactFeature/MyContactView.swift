import ComposableArchitecture
import SwiftUI
import XXModels

public struct MyContactView: View {
  public init(store: Store<MyContactState, MyContactAction>) {
    self.store = store
  }

  let store: Store<MyContactState, MyContactAction>
  @FocusState var focusedField: MyContactState.Field?

  struct ViewState: Equatable {
    init(state: MyContactState) {
      contact = state.contact
      focusedField = state.focusedField
      email = state.email
      emailConfirmation = state.emailConfirmationID != nil
      emailCode = state.emailConfirmationCode
      isRegisteringEmail = state.isRegisteringEmail
      isConfirmingEmail = state.isConfirmingEmail
      phone = state.phone
      phoneConfirmation = state.phoneConfirmationID != nil
      phoneCode = state.phoneConfirmationCode
      isRegisteringPhone = state.isRegisteringPhone
      isConfirmingPhone = state.isConfirmingPhone
      isLoadingFacts = state.isLoadingFacts
    }

    var contact: XXModels.Contact?
    var focusedField: MyContactState.Field?
    var email: String
    var emailConfirmation: Bool
    var emailCode: String
    var isRegisteringEmail: Bool
    var isConfirmingEmail: Bool
    var phone: String
    var phoneConfirmation: Bool
    var phoneCode: String
    var isRegisteringPhone: Bool
    var isConfirmingPhone: Bool
    var isLoadingFacts: Bool
  }

  public var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      Form {
        Section {
          Text(viewStore.contact?.username ?? "")
        } header: {
          Label("Username", systemImage: "person")
        }

        Section {
          if let contact = viewStore.contact {
            if let email = contact.email {
              Text(email)
              Button(role: .destructive) {
                viewStore.send(.unregisterEmailTapped)
              } label: {
                Text("Unregister")
              }
            } else {
              TextField(
                text: viewStore.binding(
                  get: \.email,
                  send: { MyContactAction.set(\.$email, $0) }
                ),
                prompt: Text("Enter email"),
                label: { Text("Email") }
              )
              .focused($focusedField, equals: .email)
              .textInputAutocapitalization(.never)
              .disableAutocorrection(true)
              .disabled(viewStore.isRegisteringEmail || viewStore.emailConfirmation)
              if viewStore.emailConfirmation {
                TextField(
                  text: viewStore.binding(
                    get: \.emailCode,
                    send: { MyContactAction.set(\.$emailConfirmationCode, $0) }
                  ),
                  prompt: Text("Enter confirmation code"),
                  label: { Text("Confirmation code") }
                )
                .focused($focusedField, equals: .emailCode)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .disabled(viewStore.isConfirmingEmail)
                Button {
                  viewStore.send(.confirmEmailTapped)
                } label: {
                  HStack {
                    Text("Confirm")
                    Spacer()
                    if viewStore.isConfirmingEmail {
                      ProgressView()
                    }
                  }
                }
                .disabled(viewStore.isConfirmingEmail)
              } else {
                Button {
                  viewStore.send(.registerEmailTapped)
                } label: {
                  HStack {
                    Text("Register")
                    Spacer()
                    if viewStore.isRegisteringEmail {
                      ProgressView()
                    }
                  }
                }
                .disabled(viewStore.isRegisteringEmail)
              }
            }
          } else {
            Text("")
          }
        } header: {
          Label("Email", systemImage: "envelope")
        }

        Section {
          if let contact = viewStore.contact {
            if let phone = contact.phone {
              Text(phone)
              Button(role: .destructive) {
                viewStore.send(.unregisterPhoneTapped)
              } label: {
                Text("Unregister")
              }
            } else {
              TextField(
                text: viewStore.binding(
                  get: \.phone,
                  send: { MyContactAction.set(\.$phone, $0) }
                ),
                prompt: Text("Enter phone"),
                label: { Text("Phone") }
              )
              .focused($focusedField, equals: .phone)
              .textInputAutocapitalization(.never)
              .disableAutocorrection(true)
              .disabled(viewStore.isRegisteringPhone || viewStore.phoneConfirmation)
              if viewStore.phoneConfirmation {
                TextField(
                  text: viewStore.binding(
                    get: \.phoneCode,
                    send: { MyContactAction.set(\.$phoneConfirmationCode, $0) }
                  ),
                  prompt: Text("Enter confirmation code"),
                  label: { Text("Confirmation code") }
                )
                .focused($focusedField, equals: .phoneCode)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .disabled(viewStore.isConfirmingPhone)
                Button {
                  viewStore.send(.confirmPhoneTapped)
                } label: {
                  HStack {
                    Text("Confirm")
                    Spacer()
                    if viewStore.isConfirmingPhone {
                      ProgressView()
                    }
                  }
                }
                .disabled(viewStore.isConfirmingPhone)
              } else {
                Button {
                  viewStore.send(.registerPhoneTapped)
                } label: {
                  HStack {
                    Text("Register")
                    Spacer()
                    if viewStore.isRegisteringPhone {
                      ProgressView()
                    }
                  }
                }
                .disabled(viewStore.isRegisteringPhone)
              }
            }
          } else {
            Text("")
          }
        } header: {
          Label("Phone", systemImage: "phone")
        }

        Section {
          Button {
            viewStore.send(.loadFactsTapped)
          } label: {
            HStack {
              Text("Reload facts")
              Spacer()
              if viewStore.isLoadingFacts {
                ProgressView()
              }
            }
          }
          .disabled(viewStore.isLoadingFacts)
        } header: {
          Text("Actions")
        }
      }
      .navigationTitle("My Contact")
      .task { viewStore.send(.start) }
      .onChange(of: viewStore.focusedField) { focusedField = $0 }
      .onChange(of: focusedField) { viewStore.send(.set(\.$focusedField, $0)) }
      .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
    }
  }
}

#if DEBUG
public struct MyContactView_Previews: PreviewProvider {
  public static var previews: some View {
    NavigationView {
      MyContactView(store: Store(
        initialState: MyContactState(),
        reducer: .empty,
        environment: ()
      ))
    }
  }
}
#endif

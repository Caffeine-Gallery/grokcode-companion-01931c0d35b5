export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'sendMessageToGrok' : IDL.Func([IDL.Text], [IDL.Text], []),
    'setApiKey' : IDL.Func([IDL.Text], [], []),
  });
};
export const init = ({ IDL }) => { return []; };

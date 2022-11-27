interface Notify {
  action: Function;
  listen: Function;
  call: Function;
}

const snackbar = {
  action: () => {},
  listen: function (func: Function) {
    this.action = func;
  },
  call: function (text: string) {
    this.action(text);
  },
} as Notify;

export default { snackbar };

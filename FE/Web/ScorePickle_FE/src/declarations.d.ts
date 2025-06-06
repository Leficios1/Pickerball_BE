declare namespace JSX {
  interface IntrinsicElements {
    'gmpx-place-picker': React.DetailedHTMLProps<
      React.HTMLAttributes<HTMLElement>,
      HTMLElement
    > & {
      placeholder?: string;
    };
    'gmpx-api-loader': React.DetailedHTMLProps<
      React.HTMLAttributes<HTMLElement>,
      HTMLElement
    > & {
      key: string;
      'solution-channel'?: string;
    };
    'gmp-map': React.DetailedHTMLProps<
      React.HTMLAttributes<HTMLElement>,
      HTMLElement
    > & {
      center?: string;
      zoom?: number;
      'map-id'?: string;
    };
    'gmp-advanced-marker': React.DetailedHTMLProps<
      React.HTMLAttributes<HTMLElement>,
      HTMLElement
    >;
  }
}

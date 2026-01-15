# wowguagua-inappbrower

capacitor inappbrowser

## Install

```bash
npm install wowguagua-inappbrower
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`openInAppBrowser(...)`](#openinappbrowser)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### openInAppBrowser(...)

```typescript
openInAppBrowser(options: OpenInAppBrowserOptions) => Promise<void>
```

| Param         | Type                                                                        |
| ------------- | --------------------------------------------------------------------------- |
| **`options`** | <code><a href="#openinappbrowseroptions">OpenInAppBrowserOptions</a></code> |

--------------------


### Interfaces


#### OpenInAppBrowserOptions

| Prop        | Type                |
| ----------- | ------------------- |
| **`url`**   | <code>string</code> |
| **`title`** | <code>string</code> |

</docgen-api>

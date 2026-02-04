// Font sizes
const double fTiny10 = 10;
const double fXTiny11 = 11;
const double fXSmall12 = 12;
const double fSmall13 = 13;
const double fLSmall14 = 14;
const double fXMedium15 = 15;
const double fMedium16 = 16;
const double fLMedium17 = 17;
const double fLarge18 = 18;
const double fXLarge20 = 20;
const double fHuge22 = 22;
const double fXHuge24 = 24;
const double fEnormous27 = 27;
const double fXEnormous30 = 30;
const double fXLEnormous32 = 32;

const double regular = 420;
const double medium = 500;
const double semiBold = 600;
const double bold = 700;

const double defaultWidth = 119;
const double fHeight = 1;

enum FontSize {
  ft10(fTiny10),
  fx11(fXTiny11),
  xs12(fXSmall12),
  sm13(fSmall13),
  sm14(fLSmall14),
  md16(fMedium16),
  lg18(fLarge18),
  xl20(fXLarge20),
  xl22(fHuge22),
  xh24(fXHuge24),
  xe30(fXEnormous30),
  xe32(fXLEnormous32);

  final double px;
  const FontSize(this.px);
}

enum Tone {
  primary, // colors.cTextPrimary
  secondary, // colors.cTextSec
  muted, // colors.cTextMuted
  active, // colors.cActive
  brand, // colors.cBtnPrimaryHover
  buy, // colors.cBtnBuy
  sell, // colors.cBtnSell
  secondaryLight, // colors.cBtnSecLghtr
  yellow, // colors.cWarningText
}

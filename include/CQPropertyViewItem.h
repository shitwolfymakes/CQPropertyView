#ifndef CQPropertyViewItem_H
#define CQPropertyViewItem_H

#include <CQUtil.h>
#include <CSafeIndex.h>

#include <QObject>
#include <QPointer>
#include <QStyleOptionViewItem>
#include <QString>
#include <QVariant>

#include <vector>
#include <cassert>

class CQPropertyViewModel;
class CQPropertyViewDelegate;
class CQPropertyViewEditorFactory;
class CQPropertyViewItemTableTip;
class QPainter;
class QWidget;

/*!
 * \brief Property view item
 */
class CQPropertyViewItem : public QObject {
  Q_OBJECT

  Q_PROPERTY(QString name     READ name       WRITE setName    )
  Q_PROPERTY(QString alias    READ alias      WRITE setAlias   )
  Q_PROPERTY(bool    editable READ isEditable WRITE setEditable)
  Q_PROPERTY(bool    hidden   READ isHidden   WRITE setHidden  )
  Q_PROPERTY(bool    inside   READ isInside   WRITE setInside  )
  Q_PROPERTY(bool    dirty    READ isDirty    WRITE setDirty   )

 public:
  using Children = std::vector<CQPropertyViewItem *>;

 public:
  CQPropertyViewItem(CQPropertyViewModel *model, CQPropertyViewItem *parent,
                     QObject *object, const QString &name);

 ~CQPropertyViewItem();

  //---

  //! check if valid
  bool isValid() const { return id_ == 0xFEEDBEEF; }

  //! get parent item
  CQPropertyViewItem *parent() const { return parent_; }

  //! get associated object
  QObject *object() const { return object_; }

  //! get/set root
  QObject *root() const { return root_; }
  void setRoot(QObject *root) { root_ = root; }

  //! get associated object from this item or child items
  QObject *hierObject() const;

  //---

  // get number of children
  int numChildren() const { return int(children_.size()); }

  //! get children
  const Children &children() const { return children_; }

  // get child
  CQPropertyViewItem *child(int i) const { return CUtil::safeIndex(children_, i); }

  //---

  //! add child
  void addChild(CQPropertyViewItem *row);

  //! remove child
  void removeChild(CQPropertyViewItem *row);

  //---

  //! get number of visible children
  int numVisibleChildren() const { return int(visibleChildren().size()); }

  //! get visible children
  const Children &visibleChildren() const;

  //! get visible child
  CQPropertyViewItem *visibleChild(int i) const { return CUtil::safeIndex(visibleChildren(), i); }

  //! invalidate cached visible children
  void invalidateVisible();

  //---

  //! get/set name
  const QString &name() const { return name_; }
  CQPropertyViewItem &setName(const QString &s) { name_ = s; return *this; }

  //! get/set alias
  const QString &alias() const { return alias_; }
  CQPropertyViewItem &setAlias(const QString &s) { alias_ = s; return *this; }

  //! get/set editable
  bool isEditable() const { return editable_; }
  CQPropertyViewItem &setEditable(bool b) { editable_ = b; return *this; }

  //! get/set hidden
  bool isHidden() const { return hidden_; }
  CQPropertyViewItem &setHidden(bool b);

  //! get/set inside
  bool isInside() const { return inside_; }
  CQPropertyViewItem &setInside(bool b) { inside_ = b; return *this; }

  //! get/set enum values
  const QStringList &values() const { return values_; }
  CQPropertyViewItem &setValues(const QStringList &v) { values_ = v; return *this; }

  //! get/set min value
  const QVariant &minValue() const { return minValue_; }
  CQPropertyViewItem &setMinValue(const QVariant &v) { minValue_ = v; return *this; }

  //! get/set max value
  const QVariant &maxValue() const { return maxValue_; }
  CQPropertyViewItem &setMaxValue(const QVariant &v) { maxValue_ = v; return *this; }

  //----

  //! get/set dirty
  bool isDirty() const { return dirty_; }
  void setDirty(bool b) { dirty_ = b; }

  const QVariant &dirtyValue() const { return dirtyValue_; }
  void setDirtyValue(const QVariant &v) { dirtyValue_ = v; }

  //----

  //! get alias name
  QString aliasName() const;

  //! get path
  QString path(const QString &sep="/", bool alias=false, CQPropertyViewItem *root=nullptr) const;

  //! get initial value as string
  QString initStr() const;

  //! get data value as string
  QString dataStr() const;

  //! set editor
  void setEditorFactory(CQPropertyViewEditorFactory *editor) { editor_ = editor; }

  //! handle click
  bool click();

  //! create editor widget
  QWidget *createEditor(QWidget *parent);

  //! set widget property from variant
  void setEditorData(const QVariant &value);

  //! get editor widget text
  QVariant getEditorData() const;

  //! initial value
  QVariant initValue() const { return initValue_; }

  //! get/set data
  QVariant data() const;
  bool setData(const QVariant &value);

  //! apply dirty value
  bool applyDirty();

  //! get tcl data
  QVariant tclData() const;

  //! get/set desc
  const QString &desc() const { return desc_; }
  CQPropertyViewItem &setDesc(const QString &s) { desc_ = s; return *this; }

  //! get type name
  QString typeName() const;

  //! is enum
  bool isEnum() const;

  //! get user type name
  QString userTypeName() const;

  //! get tip for name column
  QString nameTip(bool html=true) const;

  //! get tip for value column
  QString valueTip(bool html=true) const;

  //! paint item
  bool paint(const CQPropertyViewDelegate *delegate, QPainter *painter,
             const QStyleOptionViewItem &option, const QModelIndex &index);

 private:
  QWidget *createDefaultEdit(QWidget *parent, const QString &valueStr);

  QString getDefaultValue() const;

  QString calcTip() const;

  void addCommonType(CQPropertyViewItemTableTip &tableTip) const;

  bool isHierHidden() const;

 signals:
  //! emitted when value changed
  void valueChanged(QObject *obj, const QString &name);

 private slots:
  //! called when the editor widget is changed
  void updateValue();

//bool enumValueToString(const CQUtil::PropInfo &propInfo, int value, QString &str) const;
//bool enumStringToValue(const CQUtil::PropInfo &propInfo, const QString &str, int &value) const;

 private:
  CQPropertyViewModel*         model_    { nullptr };    //!< parent model
  uint                         id_       { 0xFEEDBEEF }; //!< unique id
  CQPropertyViewItem*          parent_   { nullptr };    //!< parent item
  QPointer<QObject>            object_;                  //!< associated objects
  QPointer<QObject>            root_;                    //!< root for object
  QString                      name_;                    //!< name
  QString                      alias_;                   //!< alias
  QString                      desc_;                    //!< description
  Children                     children_;                //!< child items
  QVariant                     initValue_;               //!< init value
  bool                         editable_ { false };      //!< is editable
  bool                         hidden_   { false };      //!< is hidden
  bool                         inside_   { false };      //!< is mouse inside
  bool                         dirty_    { false };      //!< is dirty (value changed/not applied)
  QVariant                     dirtyValue_;              //!< dirty value
  QPointer<QWidget>            widget_;                  //!< edit widget
  CQPropertyViewEditorFactory *editor_   { nullptr };    //!< editor interface
  QStringList                  values_;                  //!< enum values
  QVariant                     minValue_;                //!< min value
  QVariant                     maxValue_;                //!< max value

  Children visibleChildren_;                //!< visible child items
  bool     visibleChildrenValid_ { false }; //!< visible child items valid
  bool     visibleChildrenSet_   { false }; //!< any children hidden
};

#endif

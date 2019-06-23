# TableAnalysis

Welcome!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'table_analysis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install table_analysis

## Usage

```
doc_table_html = File.read('file/demo1.html')

TableAnalysis::Main.generator(doc_table_html, header_start_row, selected_rows)
```

> header start row, selected rows 都是从1开始
>> header start row: 找到header的tr出现在table的第几行，如果标题有多行，取第一行行号

>> selected rows: 取第几列数据,数这一行的colspan
>> 

## 举例

```
// doc
<table border="1">
  <tr>
    <td rowspan="2">月份</td>
    <td colspan='2'>开销</td>
  </tr>
  <tr>
    <td>生活</td>
    <td>工作</td>
  </tr>
  <tr>
    <td>1</td>
    <td>$70</td>
    <td>$100</td>
  </tr>
  <tr>
    <td>2</td>
    <td>$100</td>
    <td>$80</td>
  </tr>
</table>
```
取《开销》中《生活》列

headerStartRow: 1

>通常的值都是1，如果表中有脏数据，导致标题不在第一个tr中的时候，我们对应做修改。

selectedRows: [2] 

>整个table有三列，第一列月份，第二列和第三列都是开销，生活数据是第二列。


```
p TableAnalysis::Main.generator(doc, 1, 2)
```

```
返回结果 [[0, 1, -1], [-1, 1, 0], [0, 1, 0], [0, 1, 0]]
```

返回值是整个表结构，1代表要取的结果，-1代表被占用, 0代表无用数据。

当去掉-1的值后，第一行有两列数据，第二行两列，第三行3列，第四行3列，就跟html的结构一样了，
迭代表结构，根据我们获得的结果中1的位置，就知道哪些数据是有用的数据了。

以后的版本里，我会提供一个方法，把返回结果直接用数据+值的结构返回。类似[{ '0':'月份', '1': '开销', '-1': '开销'}, ...], 再提供.values返回包含1和-1的结果,0对应的值返回空字符串。
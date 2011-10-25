<?php

/**
 * XML解析类，兼容PHP4的一种XML解析类
 *
 * @package lib
 * @subpackage plugins.xml
 * @author 张立冰
 */
class XmlParse  {
    var $parser;
    var $document;
    var $current;
    var $parent;
    var $parents;

    var $last_opened_tag;

    function XmlParse($data=null) {
        $this->parser = xml_parser_create();

        xml_parser_set_option ($this->parser, XML_OPTION_CASE_FOLDING, 0);
        xml_set_object($this->parser, &$this);
        xml_set_element_handler($this->parser, 'open', 'close');
        xml_set_character_data_handler($this->parser, 'data');
    }

    function destruct() {
        xml_parser_free($this->parser);
    }

    function parse($data) {
        $this->document = array();
        $this->parent = &$this->document;
        $this->parents = array();
        $this->last_opened_tag = NULL;
        xml_parse($this->parser, $data);
        return $this->document;
    }

    function open($parser, $tag, $attributes) {
        $this->data = '';
        $this->last_opened_tag = $tag;
        if (array_key_exists($tag, $this->parent)) {
            if (is_array($this->parent[$tag]) and array_key_exists(0, $this->parent[$tag])) {
//                $key = count_numeric_items($this->parent[$tag]);
                $key = is_array($this->parent[$tag]) 
                		? count(array_filter(array_keys($this->parent[$tag]), 'is_numeric'))
                		: 0;
            } else {
                $temp = &$this->parent[$tag];
                unset($this->parent[$tag]);
                $this->parent[$tag][0] = &$temp;

                if (array_key_exists("$tag attr", $this->parent)) {
                    $temp = &$this->parent["$tag attr"];
                    unset($this->parent["$tag attr"]);
                    $this->parent[$tag]["0 attr"] = &$temp;
                }
                $key = 1;
            }
            $this->parent = &$this->parent[$tag];
        } else {
            $key = $tag;
		}
        if ($attributes) {
            $this->parent["$key attr"] = $attributes;
		}

        $this->parent[$key] = array();
        $this->parent = &$this->parent[$key];
        array_unshift($this->parents, &$this->parent);
    }

    function data($parser, $data) {
        if ($this->last_opened_tag != NULL) {
            $this->data .= $data;
		}
    }

    function close($parser, $tag) {
        if ($this->last_opened_tag == $tag) {
            $this->parent = $this->data;
            $this->last_opened_tag = NULL;
        }
        array_shift($this->parents);
        $this->parent = &$this->parents[0];
    }
}
?>